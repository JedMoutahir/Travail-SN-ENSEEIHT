import java.rmi.Remote;
import java.rmi.RemoteException;
import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.locks.Lock;
import java.util.concurrent.locks.ReentrantLock;

public class ServerObject implements Remote {

	enum LOCKS {
		NL,		// no local lock
		RLC, 	// read lock cached (not taken)
		WLC,	// write locked cached (not taken)
		RLT,	// read lock taken
		WLT,	// write lock taken
		RLT_WLC // read lock taken and write lock cached
	}
	public Object obj;
	public int id;

	private LOCKS verrou;
	private Client_itf writer;
	private List<Client_itf> readers;
	private List<Client_itf> abonnes;
	private Lock lock;

	public ServerObject(Object o, Integer id) {
		this.obj = o;
		this.id = id;
		this.verrou = LOCKS.NL;
		this.writer = null;
		this.lock = new ReentrantLock(true);
		this.readers = new ArrayList<Client_itf>();
		this.abonnes = new ArrayList<Client_itf>();
	}

	public Object lock_read(Client_itf c) {
		lock.lock();
		switch (this.verrou) {
		case NL:
			this.readers.add(c);
			this.verrou = LOCKS.RLT;
			break;
		case RLT:
			this.readers.add(c);
			break;
		case WLT:
			try {
				this.obj = this.writer.reduce_lock(this.id);
				//System.out.println("obj in lock_read in ServerObject : " + this.obj);
				this.readers.add(this.writer);
				this.writer = null;
			} catch (RemoteException e) {
				e.printStackTrace();
			} finally {
				this.writer = null;
				this.readers.add(c);
				this.verrou = LOCKS.RLT;
			}
			break;
		default:
			break;
		}
		return this.obj;
	}

	public Object lock_write(Client_itf c) {
		this.lock.lock();
		switch (this.verrou) {
		case NL:
			this.writer = c;
			this.verrou = LOCKS.WLT;
			break;
		case RLT:
			for (Client_itf cl  : this.readers) {
				try {
					//System.out.println("id in Server object in lock_write : " + id);
					cl.invalidate_reader(this.id);
				} catch (RemoteException e) {
					e.printStackTrace();
				}
			}
			this.readers.clear();
			this.writer = c;
			this.verrou = LOCKS.WLT;
			break;
		case WLT:
			try {
				//System.out.println("obj in invalidate_writer in ServerObject : " + this.obj);
				this.obj =  this.writer.invalidate_writer(id);
			} catch (RemoteException e) {
				e.printStackTrace();
			} finally {
				this.writer = c;
			}
			break;
		default:
			break;
		}
		return this.obj;
	}

	public void notifier(Object newObject) {
		for(Client_itf cl : abonnes) {
			try {
				this.obj = newObject;
				cl.callBack(this.id, newObject);
			} catch (RemoteException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
	}
	
	public void clientValidation() {
		this.lock.unlock();
	}

	public void abonner(Client_itf client) {
		// TODO Auto-generated method stub
		abonnes.add(client);
	}

	public void desabonner(Client_itf client) {
		// TODO Auto-generated method stub
		abonnes.remove(client);
	}
}
