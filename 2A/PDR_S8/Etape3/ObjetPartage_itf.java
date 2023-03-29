import java.rmi.Remote;
import java.rmi.RemoteException;

public interface ObjetPartage_itf extends Remote {
	// Retourne l'objet partag�
	public Object read() throws RemoteException;

	// �crit la nouvelle valeur de l'objet partag� et retourne le num�ro de version associ�
	public int write(Object valeur) throws RemoteException;

	// Retourne le num�ro de version actuel de l'objet partag�
	public int getVersion() throws RemoteException;
}
