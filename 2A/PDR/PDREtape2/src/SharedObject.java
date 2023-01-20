import java.io.*;

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
	
	public SharedObject(Object o, Integer id) {
		this.obj = o;
		this.id = id;
		this.verrou = LOCKS.NL;
	}
	// invoked by the user program on the client node
	public void lock_read() {
		switch (this.verrou) {
			case NL:
				this.obj = Client.lock_read(id);
				this.verrou = LOCKS.RLT;
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

	// invoked by the user program on the client node
	public void lock_write() {
		switch (this.verrou) {
			case NL:
				this.obj = Client.lock_write(id);
				this.verrou = LOCKS.WLT;
				break;
			case RLC:
				this.obj = Client.lock_write(id);
				this.verrou = LOCKS.WLT;
				break;
			case WLC:
				this.verrou = LOCKS.WLT;
				break;
		default:
			break;
		}
	}

	// invoked by the user program on the client node
	public synchronized void unlock() {
		switch (this.verrou) {
			case RLT:
				this.verrou = LOCKS.RLC;
				break;
			case WLT:
				this.verrou = LOCKS.WLC;
				break;
			case RLT_WLC:
				this.verrou = LOCKS.WLC;
				break;
			default:
				break;
		}
		this.notify();
	}


	// callback invoked remotely by the server
	public synchronized Object reduce_lock() {
		switch (this.verrou) {
			case WLT:
				try {
					this.wait();
					this.verrou = LOCKS.RLC;
				} catch (InterruptedException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
				break;
			case RLT_WLC:
				this.verrou = LOCKS.RLT;
				break;
			case WLC:
				this.verrou = LOCKS.RLC;
				break;
			default:
				break;
		}
		return this.obj;
	}

	// callback invoked remotely by the server
	public synchronized void invalidate_reader() {
		switch (this.verrou) {
			case RLC:
				this.verrou = LOCKS.NL;
				break;
			case RLT:
				try {
					this.wait();
					this.verrou = LOCKS.NL;
				} catch (InterruptedException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
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
					this.verrou = LOCKS.NL;
				} catch (InterruptedException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
				break;
			case WLC:
				this.verrou	= LOCKS.NL;
				break;
			case RLT_WLC:
				try {
					this.wait();
					this.verrou = LOCKS.NL;
				} catch (InterruptedException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
				break;
			default:
				break;
		}
		return this.obj;
	}
}
