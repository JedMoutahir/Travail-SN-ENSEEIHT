import java.rmi.Remote;
import java.rmi.RemoteException;
import java.util.Set;

public interface Server_itf extends Remote {
	
	// Enregistre un client et renvoie la liste compl�te des clients enregistr�s
	public Set<Client_itf> addClient(Client_itf client) throws RemoteException;

	// Publie un objet partag� avec un nom donn� et renvoie son identifiant unique
	public int publish(String name, Object o, boolean reset) throws RemoteException;
	
	// Recherche l'identifiant d'un objet partag� � partir de son nom
	public int lookup(String name) throws RemoteException;
	
	// Ecrit une nouvelle valeur pour un objet partag� donn�, renvoie son num�ro de version
	public int write(int idObjet, Object valeur) throws RemoteException;
}
