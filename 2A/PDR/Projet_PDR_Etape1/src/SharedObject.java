import java.io.*;
import java.rmi.RemoteException;

public class SharedObject implements Serializable, SharedObject_itf {

	Client.LOCKS lock = Client.LOCKS.NL;

	int id;

	Object obj;

	Client client;
	
	// invoked by the user program on the client node
	public void lock_read() {
		switch(this.lock) {
		case RLC :
			this.lock = Client.LOCKS.RLT;
			break;
		case NL :
			this.obj = Client.lock_read(this.id);
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
	}

	// invoked by the user program on the client node
	public void lock_write() {
		switch(this.lock) {
		case RLC :
			this.obj = Client.lock_write(this.id);
			break;
		case NL :
			this.obj = Client.lock_read(this.id);
			break;
		case RLT :
			this.obj = Client.lock_read(this.id);
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
	}

	// invoked by the user program on the client node
	public synchronized void unlock() {
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
	}


	// callback invoked remotely by the server
	public synchronized Object reduce_lock() {
		switch(this.lock) {
		case RLC :
			this.lock = Client.LOCKS.NL;
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
			this.lock = Client.LOCKS.RLT_WLC;
			break;
		case WLC :
			this.lock = Client.LOCKS.WLC;
			break;
		default :
			System.out.println("Lock error : " + this.lock.toString());
		}
		try {
			this.obj = this.client.reduce_lock(this.id);
		} catch (RemoteException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return this.obj;
	}

	// callback invoked remotely by the server
	public synchronized void invalidate_reader() {
		switch(this.lock) {
		case RLC :
			this.lock = Client.LOCKS.NL;
			break;
		case NL :
			break;
		case RLT :
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
	}

	public synchronized Object invalidate_writer() {
		switch(this.lock) {
		case RLC :
			this.lock = Client.LOCKS.NL;
			break;
		case NL :
			break;
		case RLT :
			this.lock = Client.LOCKS.NL;
			break;
		case RLT_WLC :
			this.lock = Client.LOCKS.NL;
			break;
		case WLT :
			this.lock = Client.LOCKS.NL;
			break;
		case WLC :
			this.lock = Client.LOCKS.NL;
			break;
		default :
			System.out.println("Lock error : " + this.lock.toString());
		}
		try {
			this.obj = this.client.invalidate_writer(this.id);
		} catch (RemoteException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return this.obj;
	}
}
