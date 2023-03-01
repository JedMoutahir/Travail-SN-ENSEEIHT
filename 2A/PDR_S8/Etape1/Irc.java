import java.awt.*;
import java.awt.event.*;
import java.rmi.*;
import java.io.*;
import java.net.*;
import java.util.*;
import java.lang.*;
import java.rmi.registry.*;


public class Irc extends Frame {
	public TextArea		text;
	public TextField	data;
	SharedObject		sentence;
	static String		myName;

	public static void main(String argv[]) {
		
		if (argv.length != 1) {
			System.out.println("java Irc <name>");
			return;
		}
		myName = argv[0];
	
		// initialize the system
		Client.init();
		
		// look up the IRC object in the name server
		// if not found, create it, and register it in the name server
		SharedObject s = Client.lookup("IRC");
		if (s == null) {
			System.out.println("creating the sentence object");
			s = Client.create(new Sentence());
			Client.register("IRC", s);
		}
		s.abonner(new Callback_itf() {
			private String name = Integer.toString((new java.util.Random()).nextInt(50));
			private int compteur = 0;
			public void execute() {
				compteur ++;
				System.out.println("called back Irc number " + name + " for the " + compteur + " time.");
			}
		});
		// create the graphical part
		new Irc(s);
	}

	public Irc(SharedObject s) {
	
		setLayout(new FlowLayout());
	
		text=new TextArea(10,60);
		text.setEditable(false);
		text.setForeground(Color.red);
		add(text);
	
		data=new TextField(60);
		add(data);
	
		Button write_button = new Button("write");
		write_button.addActionListener(new writeListener(this));
		add(write_button);
		Button read_button = new Button("read");
		read_button.addActionListener(new readListener(this));
		add(read_button);
		
		setSize(470,300);
		text.setBackground(Color.black); 
		show();
		
		sentence = s;
	}
}



class readListener implements ActionListener {
	Irc irc;
	public readListener (Irc i) {
		irc = i;
	}
	public void actionPerformed (ActionEvent e) {
		
		// lock the object in read mode
		irc.sentence.lock_read();
		
		// invoke the method
		String s = ((Sentence)(irc.sentence.obj)).read();
		
		// unlock the object
		irc.sentence.unlock();
		
		// display the read value
		irc.text.append(s+"\n");
	}
}

class writeListener implements ActionListener {
	Irc irc;
	public writeListener (Irc i) {
        	irc = i;
	}
	public void actionPerformed (ActionEvent e) {
		
		// get the value to be written from the buffer
        	String s = irc.data.getText();
        	
        	// lock the object in write mode
		irc.sentence.lock_write();
		
		// invoke the method
		((Sentence)(irc.sentence.obj)).write(Irc.myName+" wrote "+s);
		irc.data.setText("");
		
		// unlock the object
		irc.sentence.unlock();
	}
}

/*--------------------------*/
/*		DOESNT WORK			*/
/*--------------------------*/
class Callback implements Callback_itf {
	private SharedObject so;
	private Irc irc;
	
	public Callback(SharedObject so, Irc i) {
		this.so = so;
		this.irc = i;
	}
	
	@Override
	public void execute() {
		// TODO Auto-generated method stub
		
		System.out.println("called back");
	
		so.lock_read();

		System.out.println("passed lockread");
		
		// invoke the method
		String s = ((Sentence)(so.obj)).read();

		System.out.println("passed read");
		
		// unlock the object
		so.unlock();

		System.out.println("passed unlock");
		
		// display the read value
		//this.irc.text.append(s+"\n");
	}
	
}