import java.io.*;
import java.rmi.RemoteException;

public class SharedObject implements Serializable, SharedObject_itf {


	enum LOCKS {
		NL,		// no local lock
		RLC, 	// read lock cached (not taken)
		WLC,	// write locked cached (not taken)
		RLT,	// read lock taken
		WLT,	// write lock taken
		RLT_WLC // read lock taken and write lock cached
	}
	public Object obj;
	public Integer id;
	public LOCKS verrou;
	private boolean serialisationState = false;
	private Server_itf server;

	public SharedObject(Object o, Integer id) {
		this.obj = o;
		this.id = id;
		this.verrou = LOCKS.NL;
	}

	public SharedObject(Object o, Integer id, Server_itf server) {
		this.obj = o;
		this.id = id;
		this.verrou = LOCKS.NL;
		this.server = server;
	}

	public void lock_read() {
		switch (this.verrou) {
		case NL:
			this.obj = Client.lock_read(this.id);
			System.out.println("Le client qui n'est pas abonné lit la nouvelle valeure.");
			this.verrou = LOCKS.RLT;
			Client.clientValidation(this.id);
			break;
		case RLC:
			this.verrou = LOCKS.RLT;
			break;
		case WLC:
			this.verrou = LOCKS.RLT_WLC;
			break;
		default:
			break;
		}		
	}

	public void lock_write() {
		switch (this.verrou) {
		case NL:
			this.obj = Client.lock_write(this.id);
			this.verrou = LOCKS.WLT;
			Client.clientValidation(this.id);
			break;
		case RLC:
			this.obj = Client.lock_write(this.id);
			this.verrou = LOCKS.WLT;
			Client.clientValidation(this.id);
			break;
		case WLC:
			this.verrou = LOCKS.WLT;
			break;
		default:
			break;
		}
	}

	public synchronized void unlock() {
		switch (this.verrou) {
		case RLT:
			this.verrou = LOCKS.RLC;
			this.notify();
			break;
		case WLT:
			this.verrou = LOCKS.RLC;
			Client.notifier(this.id, this.obj);
			this.notify();
			break;
		case RLT_WLC:
			this.verrou = LOCKS.RLC;
			this.notify();
			break;
		default:
			this.notify();
			break;
		}
		//System.out.println("obj in unlock in sharedObject : " + this.obj);
	}

	public synchronized Object reduce_lock() {
		switch (this.verrou) {
		case WLT:
			try {
				//System.out.println("WLT");
				this.wait();
			} catch (InterruptedException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			this.verrou = LOCKS.RLC;
			break;
		case RLT_WLC:
			this.verrou = LOCKS.RLT;
			break;
		case WLC:
			//System.out.println("WLC");
			this.verrou = LOCKS.RLC;
			break;
		default:
			break;
		}
		//System.out.println("obj in reduce_lock : " + this.obj);
		return this.obj;
	}

	public synchronized void invalidate_reader() {
		switch (this.verrou) {
		case RLC:
			this.verrou = LOCKS.NL;
			break;
		case RLT:
			try {
				this.wait();
			} catch (InterruptedException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			this.verrou = LOCKS.NL;
			break;
		default:
			break;
		}
	}

	public synchronized Object invalidate_writer() {
		switch (this.verrou) {
		case WLT:
			try {
				this.wait();
			} catch (InterruptedException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			this.verrou = LOCKS.NL;
			break;
		case WLC:
			this.verrou	= LOCKS.NL;
			break;
		case RLT_WLC:
			try {
				this.wait();
			} catch (InterruptedException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			break;
		default:
			break;
		}
		//System.out.println("obj in invalidate_writer in sharedObject : " + this.obj);
		return this.obj;
	}

	@Override
	public void abonner() {
		// TODO Auto-generated method stub
		Client.abonner(this.id);
	}

	@Override
	public void desabonner() {
		// TODO Auto-generated method stub
		Client.desabonner(this.id);
	}
	
	public void callback(Object newObject) {
		System.out.println("L'objet du client a été mis à jour.");
		this.obj = newObject;
		this.verrou = LOCKS.RLC;
	}
}
