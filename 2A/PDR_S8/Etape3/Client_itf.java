import java.rmi.Remote;
import java.rmi.RemoteException;

public interface Client_itf extends Remote {
	// Cr�e une copie locale d'un objet partag� identifi� par son id et initialis�e avec la valeur donn�e
	public void initialiser_un_objet(int idObjet, Object valeur) throws RemoteException;

	// Demande la derni�re version de l'objet partag� identifi� par son id et enregistre le rappel de lecture
	public void enquete(int idObjet, Rappel_lec cbl) throws RemoteException;

	// Met � jour l'objet partag� identifi� par son id avec la nouvelle valeur donn�e et enregistre le rappel d'�criture
	public void mise_a_jour(int idObjet, int version, Object valeur, Rappel_ecr cbr) throws RemoteException;
}