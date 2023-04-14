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
		// Appel à la méthode publish du serveur pour publier l'objet partagé
		server.publish(String.valueOf(idObjet), valeur, true);
	}

	@Override
	public void enquete(int idObjet, Rappel_lec cbl) throws RemoteException {
		// Appel à la méthode lookup du serveur pour récupérer l'identifiant de l'objet partagé
		int id = server.lookup(String.valueOf(idObjet));
		
		// Récupération de la dernière version de l'objet partagé
		Object valeur = server.write(id, null);
		
		// Appel à la méthode réponse du rappel de lecture pour transmettre la version courante de l'objet
		cbl.reponse(server.getVersion(), valeur);
	}

	@Override
	public void mise_a_jour(int idObjet, int version, Object valeur, Rappel_ecr cbr) throws RemoteException {
		// Appel à la méthode lookup du serveur pour récupérer l'identifiant de l'objet partagé
		int id = server.lookup(String.valueOf(idObjet));
		
		// Ecriture de la nouvelle valeur pour l'objet partagé
		int newVersion = server.write(id, valeur);
		
		// Vérification que la version courante de l'objet est bien égale à la version attendue
		if (newVersion == version + 1) {
			// Appel à la méthode réponse du rappel d'écriture pour indiquer que l'écriture s'est bien déroulée
			cbr.reponse();
		} else {
			// Appel à la méthode réponse du rappel d'écriture pour indiquer que l'écriture a échoué
			cbr.reponse();
		}
	}

	public static void main(String[] args) throws Exception {
		// Récupération de l'adresse du serveur
		String url = "rmi://" + args[0] + "/SharedObjectServer";
		
		// Récupération de l'objet serveur à partir de son adresse
		Server_itf server = (Server_itf) Naming.lookup(url);

		// Création d'un nouveau client
		Clientold client = new Clientold(server);

		// Initialisation de l'objet partagé avec l'id 1 et la valeur "Hello World!"
		client.initialiser_un_objet(1, "Hello World!");

		// Récupération de la valeur de l'objet partagé avec l'id 1
		Rappel_lec cbl = new Rappel_lec_impl();
		client.enquete(1, cbl);
		System.out.println("Valeur de l'objet partagé : " + cbl.getVersion() + " " + cbl.getValeur());

		// Mise à jour de la valeur de l'objet partagé avec l'id 1, en ajoutant "Goodbye World!"
		Rappel_ecr cbr = new Rappel_ecr_impl();
		client.mise_a_jour(1, cbl.getVersion(), "Hello World! Goodbye World!", cbr);
		System.out.println("Mise à jour effectuée avec succès !");
		// Vérification de la mise à jour en récupérant la nouvelle valeur de l'objet partagé avec l'id 1
		Rappel_lec cbl2 = new Rappel_lec_impl();
		client.enquete(1, cbl2);
		System.out.println("Valeur de l'objet partagé après mise à jour : " + cbl2.getVersion() + " " + cbl2.getValeur());
	}
}
