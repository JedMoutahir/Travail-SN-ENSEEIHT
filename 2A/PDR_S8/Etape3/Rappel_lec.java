import java.rmi.Remote;
import java.rmi.RemoteException;

public interface Rappel_lec extends Remote {
	// Transmet la version courante de l'objet partagé
	public void reponse(int version, Object valeur) throws RemoteException;
}
