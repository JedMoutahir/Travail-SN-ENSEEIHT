import java.rmi.Remote;
import java.rmi.RemoteException;
import java.util.Set;

public interface Server_itf extends Remote {
	
	// Enregistre un client et renvoie la liste complète des clients enregistrés
	public Set<Client_itf> addClient(Client_itf client) throws RemoteException;

	// Publie un objet partagé avec un nom donné et renvoie son identifiant unique
	public int publish(String name, Object o, boolean reset) throws RemoteException;
	
	// Recherche l'identifiant d'un objet partagé à partir de son nom
	public int lookup(String name) throws RemoteException;
	
	// Ecrit une nouvelle valeur pour un objet partagé donné, renvoie son numéro de version
	public int write(int idObjet, Object valeur) throws RemoteException;
}
