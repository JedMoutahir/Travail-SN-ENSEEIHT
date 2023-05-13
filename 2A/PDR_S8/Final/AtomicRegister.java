import java.rmi.RemoteException;
import java.util.concurrent.locks.*;

public class AtomicRegister implements AtomicRegister_itf {
	private Object value; // la valeur courante du registre
	private int version; // le numéro de version courant du registre
	private ReentrantLock lock; // un verrou pour synchroniser l'accès à la valeur et à la version
	public AtomicRegister() {
		value = null;
		version = 0;
		lock = new ReentrantLock();
	}

	public Object read() throws RemoteException {
		lock.lock();
		try {
			return value;
		} finally {
			lock.unlock();
		}
	}

	public int write(Object newValue) throws RemoteException {
		lock.lock();
		try {
			value = newValue;
			version++;
			return version;
		} finally {
			lock.unlock();
		}
	}

	public int getVersion() throws RemoteException {
		lock.lock();
		try {
			return version;
		} finally {
			lock.unlock();
		}
	}
}