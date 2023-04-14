import java.rmi.Remote;
import java.rmi.RemoteException;

public class SharedObject implements SharedObject_itf {

	@Override
	public Object read() throws RemoteException {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public int write(Object valeur) throws RemoteException {
		// TODO Auto-generated method stub
		return 0;
	}

	@Override
	public int getVersion() throws RemoteException {
		// TODO Auto-generated method stub
		return 0;
	}
	
}
