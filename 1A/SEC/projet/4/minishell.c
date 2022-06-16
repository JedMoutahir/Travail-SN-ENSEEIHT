#include <stdio.h> /* printf */
#include <unistd.h> /* fork */
#include <stdlib.h> /* EXIT_SUCCESS */
#include <signal.h>
#include <stdbool.h>
#include <string.h>
#include <errno.h>
#include "readcmd.h"
#include <sys/types.h>
#include <sys/wait.h>

#define IS_RUNNING(bid) bg_procs[bid].state == RUN
#define IS_SUSPENDED(bid)  bg_procs[bid].state == SPD

typedef struct cmdline cmdline;

enum proc_state{NA, RUN, SPD, FIN};
char *proc_state_str[] = {"", "Running", "Suspended", "Finished"};

struct bg_proc_data {
    int pid;
    char *line;
    enum proc_state state;
    bool done;
};

typedef struct bg_proc_data bg_proc_data;

bg_proc_data *bg_procs;

//struct sigaction actChild;
//struct sigaction actInt;
//struct sigaction actStp;

int active_bg_procs = 0;
int sz_bg_procs = 4;
int cur_bg_id = 0;

int cur_fg_pid;
char *cur_fg_line;
int fg_finished = false;

int last_pipe[2];

char* format_line(char** line) {
    char* fline = malloc(sizeof(char)*1);
    int sz = 1;
    fline[0] = 0;
    for(int i = 0; line[i] != NULL; i++) {
        sz = sz + strlen(line[i]) + 1;
        if(realloc(fline, sizeof(char)*sz) == NULL) {
            free(fline);
            exit(EXIT_FAILURE);
        }
        strcat(fline, line[i]);
        strcat(fline, " ");
    }

    return fline;
}

void print_proc_info(int id) {
    if(bg_procs[id].state != FIN) {
        printf("[%i]\t%s\t\t\t%s\n", id+1, proc_state_str[bg_procs[id].state], bg_procs[id].line);
    }
    else {
        printf("[%i]\t%s\t\t\t%s\n", id+1, bg_procs[id].done ? "Done" : "Exit", bg_procs[id].line);
    }
}

void add_bg_process(int pid, char **line) {
    if(cur_bg_id == sz_bg_procs) {
        sz_bg_procs *= 2;
        if(realloc(bg_procs, sizeof(bg_proc_data)*sz_bg_procs) == NULL) {
            free(bg_procs);
            exit(EXIT_FAILURE);
        }
    }

    bg_procs[cur_bg_id].line = format_line(line);
    bg_procs[cur_bg_id].pid = pid;
    bg_procs[cur_bg_id].state = RUN;
    bg_procs[cur_bg_id].done = false;
    active_bg_procs++;
    cur_bg_id++;
}

void remove_bg_process(int id) {
    bg_procs[id].state = NA;
    active_bg_procs--;

    if(active_bg_procs == 0) {
        cur_bg_id = 0;
    }
}

int get_bgid_from_pid(int pid) {
    int id = 0;
    for(id = 0; id < sz_bg_procs; id++) {
        if (bg_procs[id].pid == pid && bg_procs[id].state != NA) {
            break;
        }
    }
    
    return id == sz_bg_procs ? -1 : id;
}

int get_latest_bgid(bool susp_only) {
    for(int i = cur_bg_id-1; i >= 0; i--) {
        if((susp_only && bg_procs[i].state == SPD) ||
                (!susp_only && (bg_procs[i].state == SPD || bg_procs[i].state == RUN))) {
            return i;
        }
    }
    return -1;
}

void on_child_exit(int chpid, int status) {
    if(chpid == cur_fg_pid) {
        fg_finished = true;
        return;
    }

    int id = get_bgid_from_pid(chpid);

    if(id == -1) {       
        // Fils d'une commande executée en foreground...
        return;
    }

    bg_procs[id].state = FIN;
    bg_procs[id].done = status == 0;
}

void on_fg_suspend() {
    fg_finished = true;
    char *arg[] = {NULL};
    add_bg_process(cur_fg_pid, arg);
    bg_procs[cur_bg_id-1].line = cur_fg_line;
    bg_procs[cur_bg_id-1].state = SPD;
    print_proc_info(cur_bg_id-1);
}

void on_fg_killed() {
    fg_finished = true;
}
void on_child_suspend(int chpid) {
    if(chpid == cur_fg_pid) {
        on_fg_suspend();
        return;
    }

    int id = get_bgid_from_pid(chpid);

    if(id == -1) {       
        // Fils d'une commande executée en foreground...
        return;
    }

    bg_procs[id].state = SPD;
    print_proc_info(id);
}

void on_child_continue(int chpid) {
    int id = get_bgid_from_pid(chpid);

    if(id == -1) {       
        // Fils d'une commande executée en foreground...
        return;
    }

    bg_procs[id].state = RUN;
    print_proc_info(id);
}

// HANDLERS

void sigchild_handler(int sig) {
    int codeTerm;
    pid_t chpid;
    do {
        chpid = waitpid(-1, &codeTerm, WNOHANG|WSTOPPED|WCONTINUED);
        if(chpid == -1 && errno != ECHILD) {
            perror("waitpid");
            exit(EXIT_FAILURE);
        }
        else if(chpid > 0) {
            if(WIFSTOPPED(codeTerm)) {
                on_child_suspend(chpid);
            }
            else if(WIFCONTINUED(codeTerm)) {
                on_child_continue(chpid);
            }
            else if(WIFEXITED(codeTerm)) {
                on_child_exit(chpid, WEXITSTATUS(codeTerm));
            }
            else if(WIFSIGNALED(codeTerm)) {
                on_child_exit(chpid, -1);
            }
        }
    } while(chpid > 0);
}

void sigint_handler(int signo) {
	if (cur_fg_pid == -1) {
        return;
    }

    printf("\n");
    kill(cur_fg_pid, SIGKILL);
    //on_fg_killed();
}

void sigtstp_handler(int signo) {
    if (cur_fg_pid == -1) {
        return;
    }

    printf("\n");
    kill(cur_fg_pid, SIGSTOP);
}

// COMMANDES

void call_cd(char** line){//cmdline cmd) {

    if (line[1] == NULL) {
        return;
    }
    else if(line[2] != NULL) {
        printf("cd: too many arguments\n");
        return;
    }
    
    char *arg = line[1];//cmd.seq[0][1];
    int res = chdir(arg);
    if (res != 0) {
        perror(arg);
    }
}

void exit_bash() {
    for(int i = 0; i < cur_bg_id; i++) {
        if(IS_RUNNING(i) || IS_SUSPENDED(i)) {
            kill(bg_procs[i].pid, SIGKILL);
        }
    }
    exit(EXIT_SUCCESS);
}

void show_jobs() {
    if (active_bg_procs == 0) {
        return;
    }
    
    for(int i = 0; i < sz_bg_procs; i++) {
        if (bg_procs[i].state != NA && bg_procs[i].state != FIN) {
            print_proc_info(i);
        }
    }
}

bool is_valid_proc(int id, const char cmd[], bool suspended) {
    if(id < 0) {
        printf("%s: job id must be a number > 0\n", cmd);
        return false;
    }

    if(id >= sz_bg_procs || (bg_procs[id].state != RUN && bg_procs[id].state != SPD)) {
        printf("%s: job [%i] does not exist\n", cmd, id+1);
        return false;
    }

    if(suspended && bg_procs[id].state != SPD) {
        printf("%s: job [%i] is not suspended\n", cmd, id+1);
        return false;
    }

    return true;
}

void stop_proc(char* str_id) {
    int id;
    if(str_id == NULL) {
        id = get_latest_bgid(true);
        if(id == -1) {
            printf("stop: current: no such job\n");
            return;
        }
    }
    else {
        id = atoi(str_id)-1;
    }

    if (!is_valid_proc(id, "stop", false)) {
        return;
    }
    

    if(bg_procs[id].state == SPD) {
        printf("stop: job [%i] already suspended\n", id+1);
        return;
    }

    kill(bg_procs[id].pid, SIGSTOP);
    sleep(1);
}

void move_bg(char* str_id) {
    int id;
    if(str_id == NULL) {
        id = get_latest_bgid(true);
        if(id == -1) {
            printf("bg: current: no such job\n");
            return;
        }
    }
    else {
        id = atoi(str_id)-1;
    }
    
    if(!is_valid_proc(id, "bg", true)) {
        return;
    }

    kill(bg_procs[id].pid, SIGCONT);
    sleep(1);
}

void move_fg(char* str_id) {
    int id;
    if(str_id == NULL) {
        id = get_latest_bgid(false);
        if(id == -1) {
            printf("fg: current: no such job\n");
            return;
        }
    }
    else {
        id = atoi(str_id)-1;
    }

    if(!is_valid_proc(id, "fg", false)) {
        return;
    }

    if(bg_procs[id].state == SPD) {
        kill(bg_procs[id].pid, SIGCONT);
    }
    remove_bg_process(id);

    printf("%s\n", bg_procs[id].line);
    cur_fg_pid = bg_procs[id].pid;
    cur_fg_line = bg_procs[id].line;
    fg_finished = false;
    while(!fg_finished) {
        sleep(5);
    }
}

// EXECUTION

int exec_cmd(cmdline cmd, int cmd_id) {
    pid_t pidFils;
    
	bool last_cmd = cmd.seq[cmd_id+1] == NULL;
    int pp[2];
    if(!last_cmd && pipe(pp) == -1) {
        perror("pipe");
        return 0;
    }
    
    pidFils = fork();
    if (pidFils == -1) { // Anomalie
    	perror("error fork");
        return 0;
	}
	
    if (pidFils == 0) {
        sigset_t block_set;
        sigemptyset(&block_set);
        sigaddset(&block_set, SIGTSTP);
        sigaddset(&block_set, SIGINT);
        sigprocmask(SIG_BLOCK, &block_set, NULL);
		if (cmd_id == 0) {
		    if(cmd.in != NULL) {
		        //freopen(cmd.in, "r", stdin);
		        fd_set fd;
		        FD_ZERO(&fd);
		        FD_SET(STDIN_FILENO, &fd);
		        select(FD_SETSIZE, &fd, NULL, NULL, NULL);
		    }
        } else {
            // STDOUT pipe already closed...
            if(last_pipe[0] > -1) {
                dup2(last_pipe[0], STDIN_FILENO);
            }
            else {
                // bugfix pour les cas où on a une commande interne entre
                // les commandes (ex: "cat file | bg | wc -w")
                int fakepipe[2];
                pipe(fakepipe);
                close(fakepipe[1]);
                dup2(fakepipe[0], STDIN_FILENO);
            }
        }
        if (last_cmd) {
		    if(cmd.out != NULL) {
		        //freopen(cmd.out, "w", stdout);
		        fd_set fd;
		        FD_ZERO(&fd);
		        FD_SET(STDOUT_FILENO, &fd);
		        select(FD_SETSIZE, &fd, NULL, NULL, NULL);
		    }
		} else {
            close(pp[0]);
            dup2(pp[1], STDOUT_FILENO);
        }
        execvp(cmd.seq[cmd_id][0], cmd.seq[cmd_id]);
        exit(EXIT_FAILURE);
    }
    // Ici on est sur que c'est le parent qui execute.
	if(!last_cmd) {
        close(pp[1]);
    }
    if(last_pipe[0] > -1) {
        close(last_pipe[0]);
    }
    last_pipe[0] = pp[0];
    last_pipe[1] = pp[1];

    return pidFils;
}

void post_exec_cmd() {
    for(int i = 0; i < sz_bg_procs; i++) {
        if (bg_procs[i].state != FIN) {
            continue;
        }
        
        remove_bg_process(i);
        print_proc_info(i);
    }
}

void pre_exec_cmd(cmdline cmd) {
    int cmd_id = 0;
    int last_pid;
    last_pipe[0] = -1;
    last_pipe[1] = -1;

    while(cmd.seq[cmd_id] != NULL) {
        char* tmp = cmd.seq[cmd_id][0];
        bool intern_cmd = true;
        last_pid = 0;

        if (strcmp(tmp, "cd") == 0) {
            call_cd(cmd.seq[cmd_id]);
        }
        else if(strcmp(tmp, "exit") == 0) {
            exit_bash();
        }
        else if(strcmp(tmp, "lj") == 0) {
            show_jobs();
        }
        else if(strcmp(tmp, "sj") == 0) {
            stop_proc(cmd.seq[cmd_id][1]);
        }
        else if(strcmp(tmp, "bg") == 0) {
            move_bg(cmd.seq[cmd_id][1]);
        }
        else if(strcmp(tmp, "fg") == 0) {
            move_fg(cmd.seq[cmd_id][1]);
        }
        else {
            intern_cmd = false;
            last_pid = exec_cmd(cmd, cmd_id);
        }

        if(intern_cmd && last_pipe[0] > -1) {
            close(last_pipe[0]);
            last_pipe[0] = -1;
        }

        cmd_id++;
    }

    if(last_pid == 0) {
        return;
    }

    if(cmd.backgrounded != NULL) {
        add_bg_process(last_pid, cmd.seq[0]);
        printf("[%i] %i\n", cur_bg_id, last_pid);
        return;
    }

    fg_finished = false;
    cur_fg_pid = last_pid;
    cur_fg_line = format_line(cmd.seq[cmd_id-1]);
    while(!fg_finished) {
        sleep(5);
    }
}

void set_sigactions() {
//struct sigaction actChild;
//struct sigaction actInt;
//struct sigaction actStp;
	struct sigaction actChild, actInt, actStp;
    sigemptyset(&actChild.sa_mask);
    sigemptyset(&actInt.sa_mask);
    sigemptyset(&actStp.sa_mask);
    actChild.sa_flags = 0;
    actInt.sa_flags = 0;
    actStp.sa_flags = 0;
    actChild.sa_handler = sigchild_handler;
    actInt.sa_handler = sigint_handler;
    actStp.sa_handler = sigtstp_handler;
    sigaction(SIGCHLD, &actChild, NULL);
    sigaction(SIGINT, &actInt, NULL);
    sigaction(SIGTSTP, &actStp, NULL);
}

int main () {
    cmdline *p_cmd;

    bg_procs = malloc(sizeof(bg_proc_data)*sz_bg_procs);
    set_sigactions();
    
    while(1) {
        cur_fg_pid = -1;
        printf("sh-3.2$ ");
        p_cmd = readcmd();
        if (p_cmd != NULL) {
            pre_exec_cmd(*p_cmd);
            post_exec_cmd();
        }
    }
    
    return EXIT_SUCCESS;
}
