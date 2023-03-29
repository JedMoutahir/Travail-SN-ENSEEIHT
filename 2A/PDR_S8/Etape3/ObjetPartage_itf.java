import java.rmi.Remote;
import java.rmi.RemoteException;

public interface ObjetPartage_itf extends Remote {
	// Retourne l'objet partagé
	public Object read() throws RemoteException;

	// Écrit la nouvelle valeur de l'objet partagé et retourne le numéro de version associé
	public int write(Object valeur) throws RemoteException;

	// Retourne le numéro de version actuel de l'objet partagé
	public int getVersion() throws RemoteException;
}
