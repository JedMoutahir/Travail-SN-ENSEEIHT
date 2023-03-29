import java.rmi.RemoteException;

public interface AtomicRegister_itf {
	// retourne la valeur courante du registre
	public Object read() throws RemoteException;

	//écrit une nouvelle valeur dans le registre, renvoie le numéro de version
	public int write(Object value) throws RemoteException;

	//renvoie le numéro de version courant du registre
	public int getVersion() throws RemoteException;

}