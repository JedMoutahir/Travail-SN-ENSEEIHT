/* ------------------------------------------------------- 
		Les packages Java qui doivent etre importes.
 */
import java.lang.*;
import java.net.InetAddress;
import java.net.MalformedURLException;
import java.net.UnknownHostException;
import java.awt.*;
import java.awt.event.*;
import java.applet.*;
import java.rmi.*;
import javax.swing.*;



/* ------------------------------------------------------- 
		Implementation de l'application
 */

public class Saisie extends JApplet {
	private static final long serialVersionUID = 1;
	TextField nom, email;
	Choice carnets;
	Label message;

	int port = 4000;

	String URL1, URL2;

	public void init() {
		URL1 = "//localhost:" + port + "/carnet1";
		URL2 = "//localhost:" + port + "/carnet2";

		setSize(300,200);
		setLayout(new GridLayout(6,2));
		add(new Label("  Nom : "));
		nom = new TextField(30);
		add(nom);
		add(new Label("  Email : "));
		email = new TextField(30);
		add(email);
		add(new Label("  Carnet : "));
		carnets = new Choice();
		carnets.addItem("Carnet1");
		carnets.addItem("Carnet2");
		add(carnets);
		add(new Label(""));
		add(new Label(""));
		Button Abutton = new Button("Ajouter");
		Abutton.addActionListener(new AButtonAction());
		add(Abutton);
		Button Cbutton = new Button("Consulter");
		Cbutton.addActionListener(new CButtonAction());
		add(Cbutton);
		message = new Label();
		add(message);
	}

	// La reaction au bouton Consulter
	class CButtonAction implements ActionListener {
		public void actionPerformed(ActionEvent ae) {
			String n, c;
			n = nom.getText();
			c = carnets.getSelectedItem();
			message.setText("Consulter("+n+","+c+")        ");
			// DO IT
			int port = 4000;
			String URL;
			try {
				System.out.println(URL1);
				Carnet carnet = (Carnet) Naming.lookup(URL1);

				if(c == "Carnet2") {
					carnet = (Carnet) Naming.lookup(URL2);
				}

				message.setText(carnet.Consulter(n, true).getEmail());

			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
	}
	// La reaction au bouton Ajouter
	class AButtonAction implements ActionListener {
		public void actionPerformed(ActionEvent ae) {
			String n, em, c;
			n = nom.getText();
			em = email.getText();
			c = carnets.getSelectedItem();
			message.setText("Ajouter("+n+","+em+","+c+")        ");
			// DO IT
			int port = 4000;
			String URL;
			try {

				System.out.println(URL1);
				Carnet carnet = (Carnet) Naming.lookup(URL1);

				if(c == "Carnet2") {
					carnet = (Carnet) Naming.lookup(URL2);
				}

				carnet.Ajouter(new SFicheImpl(n, em));

			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
	}

	public static void main(String args[]) {
		Saisie a = new Saisie();
		a.init();
		a.start();
		JFrame frame = new JFrame("Applet");
		frame.setSize(400,200);
		frame.getContentPane().add(a);
		frame.setVisible(true);
	}

}


