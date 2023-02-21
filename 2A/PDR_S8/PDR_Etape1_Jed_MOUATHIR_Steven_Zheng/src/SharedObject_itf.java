public interface SharedObject_itf {
	public void lock_read();
	public void lock_write();
	public void unlock();
	public void abonner(Callback_itf callback);
	public void desabonner(Callback_itf callback);
}