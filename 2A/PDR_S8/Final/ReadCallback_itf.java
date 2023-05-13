import java.rmi.RemoteException;

public interface ReadCallback_itf extends java.rmi.Remote {
	public void reponse(int version, Object obj)  throws RemoteException;
}