import java.rmi.Remote;
import java.rmi.RemoteException;

public interface Rappel_lec extends Remote {
	// Transmet la version courante de l'objet partag�
	public void reponse(int version, Object valeur) throws RemoteException;
}
