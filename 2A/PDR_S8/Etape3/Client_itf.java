import java.rmi.Remote;
import java.rmi.RemoteException;

public interface Client_itf extends Remote {
	// Crée une copie locale d'un objet partagé identifié par son id et initialisée avec la valeur donnée
	public void initialiser_un_objet(int idObjet, Object valeur) throws RemoteException;

	// Demande la dernière version de l'objet partagé identifié par son id et enregistre le rappel de lecture
	public void enquete(int idObjet, Rappel_lec cbl) throws RemoteException;

	// Met à jour l'objet partagé identifié par son id avec la nouvelle valeur donnée et enregistre le rappel d'écriture
	public void mise_a_jour(int idObjet, int version, Object valeur, Rappel_ecr cbr) throws RemoteException;
}