import java.rmi.Remote;
import java.rmi.RemoteException;

public interface Rappel_ecr extends Remote {
	// Indique que la mise à jour de l'objet partagé a été effectuée avec succès
	public void reponse() throws RemoteException;
}
