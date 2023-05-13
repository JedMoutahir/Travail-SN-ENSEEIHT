import java.rmi.Naming;
import java.rmi.RemoteException;
import java.rmi.server.UnicastRemoteObject;

public class Clientold extends UnicastRemoteObject implements Client_itf {

	private static final long serialVersionUID = 1L;
	private Server_itf server;

	public Clientold(Server_itf server) throws RemoteException {
		this.server = server;
	}

	@Override
	public void initialiser_un_objet(int idObjet, Object valeur) throws RemoteException {
		// Appel � la m�thode publish du serveur pour publier l'objet partag�
		server.publish(String.valueOf(idObjet), valeur, true);
	}

	@Override
	public void enquete(int idObjet, Rappel_lec cbl) throws RemoteException {
		// Appel � la m�thode lookup du serveur pour r�cup�rer l'identifiant de l'objet partag�
		int id = server.lookup(String.valueOf(idObjet));
		
		// R�cup�ration de la derni�re version de l'objet partag�
		Object valeur = server.write(id, null);
		
		// Appel � la m�thode r�ponse du rappel de lecture pour transmettre la version courante de l'objet
		cbl.reponse(server.getVersion(), valeur);
	}

	@Override
	public void mise_a_jour(int idObjet, int version, Object valeur, Rappel_ecr cbr) throws RemoteException {
		// Appel � la m�thode lookup du serveur pour r�cup�rer l'identifiant de l'objet partag�
		int id = server.lookup(String.valueOf(idObjet));
		
		// Ecriture de la nouvelle valeur pour l'objet partag�
		int newVersion = server.write(id, valeur);
		
		// V�rification que la version courante de l'objet est bien �gale � la version attendue
		if (newVersion == version + 1) {
			// Appel � la m�thode r�ponse du rappel d'�criture pour indiquer que l'�criture s'est bien d�roul�e
			cbr.reponse();
		} else {
			// Appel � la m�thode r�ponse du rappel d'�criture pour indiquer que l'�criture a �chou�
			cbr.reponse();
		}
	}

	public static void main(String[] args) throws Exception {
		// R�cup�ration de l'adresse du serveur
		String url = "rmi://" + args[0] + "/SharedObjectServer";
		
		// R�cup�ration de l'objet serveur � partir de son adresse
		Server_itf server = (Server_itf) Naming.lookup(url);

		// Cr�ation d'un nouveau client
		Clientold client = new Clientold(server);

		// Initialisation de l'objet partag� avec l'id 1 et la valeur "Hello World!"
		client.initialiser_un_objet(1, "Hello World!");

		// R�cup�ration de la valeur de l'objet partag� avec l'id 1
		Rappel_lec cbl = new Rappel_lec_impl();
		client.enquete(1, cbl);
		System.out.println("Valeur de l'objet partag� : " + cbl.getVersion() + " " + cbl.getValeur());

		// Mise � jour de la valeur de l'objet partag� avec l'id 1, en ajoutant "Goodbye World!"
		Rappel_ecr cbr = new Rappel_ecr_impl();
		client.mise_a_jour(1, cbl.getVersion(), "Hello World! Goodbye World!", cbr);
		System.out.println("Mise � jour effectu�e avec succ�s !");
		// V�rification de la mise � jour en r�cup�rant la nouvelle valeur de l'objet partag� avec l'id 1
		Rappel_lec cbl2 = new Rappel_lec_impl();
		client.enquete(1, cbl2);
		System.out.println("Valeur de l'objet partag� apr�s mise � jour : " + cbl2.getVersion() + " " + cbl2.getValeur());
	}
}
