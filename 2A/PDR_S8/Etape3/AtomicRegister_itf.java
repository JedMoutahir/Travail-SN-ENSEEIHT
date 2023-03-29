import java.rmi.RemoteException;

public interface AtomicRegister_itf {
	// retourne la valeur courante du registre
	public Object read() throws RemoteException;

	//�crit une nouvelle valeur dans le registre, renvoie le num�ro de version
	public int write(Object value) throws RemoteException;

	//renvoie le num�ro de version courant du registre
	public int getVersion() throws RemoteException;

}