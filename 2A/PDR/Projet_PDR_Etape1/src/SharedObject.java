import java.io.*;
import java.rmi.RemoteException;

public class SharedObject implements Serializable, SharedObject_itf {

	Client.LOCKS lock = Client.LOCKS.NL;

	int id;
	Object obj;
	private java.util.concurrent.locks.ReentrantLock moniteur;
	private java.util.concurrent.locks.Condition condLock;
	private java.util.concurrent.locks.Condition condUnLock;


	public SharedObject(int id) {
		this.id = id;
		this.obj = null;
		this.lock = Client.LOCKS.NL;
		this.moniteur = new java.util.concurrent.locks.ReentrantLock();
		this.condLock = this.moniteur.newCondition();
		this.condUnLock = this.moniteur.newCondition();
	}

	// invoked by the user program on the client node
	public void lock_read() {
		this.moniteur.lock();

		switch(this.lock) {
		case RLC :
			this.lock = Client.LOCKS.RLT;
			break;
		case NL :
			this.moniteur.unlock();
			this.obj = Client.lock_read(this.id);
			this.moniteur.lock();
			break;
		case RLT :
			break;
		case RLT_WLC :
			break;
		case WLT :
			break;
		case WLC :
			break;
		default :
			System.out.println("Lock error : " + this.lock.toString());
		}

		this.condLock.signal();
		this.moniteur.unlock();	
	}

	// invoked by the user program on the client node
	public void lock_write() {
		this.moniteur.lock();

		switch(this.lock) {
		case RLC :
			this.moniteur.unlock();
			this.obj = Client.lock_write(this.id);
			this.moniteur.lock();
			break;
		case NL :
			this.moniteur.unlock();
			this.obj = Client.lock_read(this.id);
			this.moniteur.lock();
			break;
		case RLT :
			this.moniteur.unlock();
			this.obj = Client.lock_read(this.id);
			this.moniteur.lock();
			break;
		case RLT_WLC :
			this.lock = Client.LOCKS.WLT;
			break;
		case WLT :
			break;
		case WLC :
			this.lock = Client.LOCKS.WLT;
			break;
		default :
			System.out.println("Lock error : " + this.lock.toString());
		}

		this.condLock.signal();
		this.moniteur.unlock();	
	}

	// invoked by the user program on the client node
	public synchronized void unlock() {
		this.moniteur.lock();
		
		switch(this.lock) {
		case RLC :
			break;
		case NL :
			break;
		case RLT :
			this.lock = Client.LOCKS.RLC;
			break;
		case RLT_WLC :
			this.lock = Client.LOCKS.RLC;
			break;
		case WLT :
			this.lock = Client.LOCKS.WLC;
			break;
		case WLC :
			this.lock = Client.LOCKS.WLC;
			break;
		default :
			System.out.println("Lock error : " + this.lock.toString());
		}

		this.condUnLock.signal();
		this.moniteur.unlock();	
	}


	// callback invoked remotely by the server
	public synchronized Object reduce_lock() {
		this.moniteur.lock();
		
		switch(this.lock) {
		case RLC :
			this.condLock.awaitUninterruptibly();
			this.lock = Client.LOCKS.NL;
			break;
		case NL :
			this.condLock.awaitUninterruptibly();
			break;
		case RLT :
			this.condLock.awaitUninterruptibly();
			this.lock = Client.LOCKS.RLC;
			break;
		case RLT_WLC :
			this.lock = Client.LOCKS.RLC;
			break;
		case WLT :
			this.condUnLock.awaitUninterruptibly();
			this.lock = Client.LOCKS.RLT_WLC;
			break;
		case WLC :
			this.lock = Client.LOCKS.WLC;
			break;
		default :
			System.out.println("Lock error : " + this.lock.toString());
		}
		//		try {
		//			this.obj = this.client.reduce_lock(this.id);
		//		} catch (RemoteException e) {
		//			e.printStackTrace();
		//		}
		
		this.moniteur.unlock();
		
		return this.obj;
	}

	// callback invoked remotely by the server
	public synchronized void invalidate_reader() {
		this.moniteur.lock();
		
		switch(this.lock) {
		case RLC :
			this.lock = Client.LOCKS.NL;
			break;
		case NL :
			this.condLock.awaitUninterruptibly();
			break;
		case RLT :
			this.condUnLock.awaitUninterruptibly();
			this.lock = Client.LOCKS.NL;
			break;
		case RLT_WLC :
			this.lock = Client.LOCKS.NL;
			break;
		case WLT :
			System.out.println("Lock error invalidate_reader on a writer : " + this.lock.toString());
			break;
		case WLC :
			this.lock = Client.LOCKS.NL;
			break;
		default :
			System.out.println("Lock error : " + this.lock.toString());
		}
		
		this.moniteur.unlock();
	}

	public synchronized Object invalidate_writer() {
		this.moniteur.lock();
		
		switch(this.lock) {
		case RLC :
			this.condLock.awaitUninterruptibly();
			this.lock = Client.LOCKS.NL;
			break;
		case NL :
			this.condLock.awaitUninterruptibly();
			break;
		case RLT :
			this.condLock.awaitUninterruptibly();
			this.lock = Client.LOCKS.NL;
			break;
		case RLT_WLC :
			this.lock = Client.LOCKS.NL;
			break;
		case WLT :
			this.condUnLock.awaitUninterruptibly();
			this.lock = Client.LOCKS.NL;
			break;
		case WLC :
			this.lock = Client.LOCKS.NL;
			break;
		default :
			System.out.println("Lock error : " + this.lock.toString());
		}
		//		try {
		//			this.obj = this.client.invalidate_writer(this.id);
		//		} catch (RemoteException e) {
		//			// TODO Auto-generated catch block
		//			e.printStackTrace();
		//		}
		
		this.moniteur.unlock();
		
		return this.obj;
	}
}
