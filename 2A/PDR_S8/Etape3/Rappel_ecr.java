import java.rmi.Remote;
import java.rmi.RemoteException;

public interface Rappel_ecr extends Remote {
	// Indique que la mise � jour de l'objet partag� a �t� effectu�e avec succ�s
	public void reponse() throws RemoteException;
}
