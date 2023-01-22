
public class TestPlus1 {
	public static void main(String[] args) {
		Client.init();
		IntContainer_itf nbContainer = (IntContainer_itf) Client.lookup("nb");

		if (nbContainer == null) {
			nbContainer = (IntContainer_itf) Client.create(new IntContainer());
			System.out.println("called Client.create");
			Client.register("nb", nbContainer);
		}

		nbContainer.lock_write();
		nbContainer.put(nbContainer.get()+1);
		nbContainer.unlock();
		//System.out.println("fin Test");
	}
}

class Validation {
	public static void main(String[] args) {
		Client.init();
		IntContainer_itf nbContainer = (IntContainer_itf) Client.lookup("nb");

		if (nbContainer == null) {
			nbContainer = (IntContainer_itf) Client.create(new IntContainer());
			Client.register("nb", nbContainer);
		}

		nbContainer.lock_read();
		System.out.println("valeure lue " + nbContainer.get());
		nbContainer.unlock();
	}
}