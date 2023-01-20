import java.rmi.Remote;
import java.rmi.RemoteException;
import java.util.ArrayList;
import java.util.List;

public class ServerObject implements Remote {
	
	private enum LOCKS {
		NL,
		RL,
		WL
	}
	public Object obj;
	public int id;
	
	private LOCKS verrou;
	private Client_itf writer;
	private List<Client_itf> readers;
	
	public ServerObject(Object o, Integer id) {
		this.obj = o;
		this.id = id;
		this.verrou = LOCKS.NL;
		this.writer = null;
		this.readers = new ArrayList<>();
	}
	
	public Object lock_read(Client_itf c) {
		switch (this.verrou) {
			case NL:
				this.verrou = LOCKS.RL;
				break;
			case RL:
				break;
			case WL:
				try {
					this.obj =  writer.reduce_lock(id);
					readers.add(writer);
					writer = null;
				} catch (RemoteException e) {
					e.printStackTrace();
				}
				this.verrou = LOCKS.RL;
				break;
			default:
				break;
		}
		readers.add(c);
		return this.obj;
	}
	
	public Object lock_write(Client_itf c) {
		switch (this.verrou) {
		case NL:
			this.verrou = LOCKS.WL;
			writer = c;
			break;
		case RL:
			writer = c;
			this.verrou = LOCKS.WL;
			for (Client_itf cl  : readers) {
				try {
					cl.invalidate_reader(id);
				} catch (RemoteException e) {
					e.printStackTrace();
				}
				
			}
			readers.clear();
			break;
		case WL:
			try {
				this.obj =  writer.invalidate_writer(id);
				writer = c;
			} catch (RemoteException e) {
				e.printStackTrace();
			}
			break;
		default:
			break;
		}
		return this.obj;
	}
	
}
