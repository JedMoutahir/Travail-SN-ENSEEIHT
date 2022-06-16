#include <stdio.h> /* printf */
#include <unistd.h> /* fork */
#include <stdlib.h> /* EXIT_SUCCESS */
#include <signal.h> // SIGCHILD
#include <stdbool.h>
#include <string.h>
#include <errno.h>
#include "readcmd.h"
#include "readcmd.c"
#include <sys/types.h>
#include <sys/wait.h>

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
int active_bg_procs = 0;
int sz_bg_procs = 4;
int cur_bg_id = 0;

int cur_fg_pid;
char *cur_fg_line;
int fg_finished = false;

char* format_line(char** line) {
    char* fline = malloc(sizeof(char)*1);
    int sz = 1;
    fline[0] = 0;
    for(int i = 0; line[i] != NULL; i++) {
        sz = sz + strlen(line[i]) + 1;
        //realloc(fline, sizeof(char)*sz);
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
        //realloc(bg_procs, sizeof(bg_proc_data)*sz_bg_procs);
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
    on_fg_killed();
}

void sigtstp_handler(int signo) {
    if (cur_fg_pid == -1) {
        return;
    }

    printf("\n");
    kill(cur_fg_pid, SIGSTOP);
}

void call_cd(cmdline cmd) {
    char **line = cmd.seq[0];

    if (line[1] == NULL) {
        return;
    }
    else if(line[2] != NULL) {
        printf("cd: too many arguments\n");
        return;
    }
    
    char *arg = cmd.seq[0][1];
    int res = chdir(arg);
    if (res != 0) {
        perror(arg);
    }
}

void exec_cmd(cmdline cmd) {
    pid_t pidFils;

    pidFils = fork();
    if (pidFils == -1)  // Anomalie
        return;

    if (pidFils == 0) {
        sigset_t block_set;
        sigemptyset(&block_set);
        sigaddset(&block_set, SIGTSTP);
        sigaddset(&block_set, SIGINT);
        sigprocmask(SIG_BLOCK, &block_set, NULL);

        if(cmd.in != NULL) {
            freopen(cmd.in, "r", stdin);
        }
        if(cmd.out != NULL) {
            freopen(cmd.out, "w", stdout);
        }
        execvp(cmd.seq[0][0], cmd.seq[0]);
        exit(EXIT_FAILURE);
    }
    // Ici on est sur que c'est le parent qui execute.

    if(cmd.backgrounded != NULL) {
        add_bg_process(pidFils, cmd.seq[0]);
        printf("[%i] %i\n", cur_bg_id, pidFils);
        return;
    }

    fg_finished = false;
    cur_fg_pid = pidFils;
    cur_fg_line = format_line(cmd.seq[0]);
    while(!fg_finished) {
        sleep(5);
    }
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
    int id = atoi(str_id);
    
    if (!is_valid_proc(--id, "stop", false)) {
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
    int id = atoi(str_id);
    
    if(!is_valid_proc(--id, "bg", true)) {
        return;
    }

    kill(bg_procs[id].pid, SIGCONT);
    sleep(1);
}

void move_fg(char* str_id) {
    int id = atoi(str_id);

    if(!is_valid_proc(--id, "fg", false)) {
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
    if(cmd.seq[0] == NULL) {
        // Pas de commande...
        return;
    }

    char* tmp = cmd.seq[0][0];
    if (strcmp(tmp, "cd") == 0) {
        call_cd(cmd);
    }
    else if(strcmp(tmp, "exit") == 0) {
        exit(EXIT_SUCCESS);
    }
    else if(strcmp(tmp, "lj") == 0) {
        show_jobs();
    }
    else if(strcmp(tmp, "sj") == 0) {
        if(cmd.seq[0][1] != NULL){
            stop_proc(cmd.seq[0][1]);
        }
    }
    else if(strcmp(tmp, "bg") == 0) {
        if(cmd.seq[0][1] != NULL){
            move_bg(cmd.seq[0][1]);
        }
    }
    else if(strcmp(tmp, "fg") == 0) {
        if(cmd.seq[0][1] != NULL){
            move_fg(cmd.seq[0][1]);
        }
    }
    else {
        exec_cmd(cmd);
    }
}

void set_sigactions() {
    signal(SIGCHLD, sigchild_handler);
    signal(SIGINT, sigint_handler);
    signal(SIGTSTP, sigtstp_handler);
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
