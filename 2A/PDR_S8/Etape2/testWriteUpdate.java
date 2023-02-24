import java.util.ArrayList;
import java.util.List;

public class testWriteUpdate {

	List<Irc> ircList;
	
	public testWriteUpdate(List<Irc> liste) {
		// TODO Auto-generated constructor stub
		this.ircList = liste;
	}

	public static void main(String[] args) {
		if (args.length != 1) {
			System.out.println("java testWriteUpdate <name>");
			return;
		}
		int n = Integer.parseInt(args[0]);
		List<Irc> liste = new ArrayList<Irc>();;
		for(int i = 0 ; i < n ; i ++) {
			Client.init();

			SharedObject s = Client.lookup("IRC");
			if (s == null) {
				System.out.println("creating the sentence object");
				s = Client.create(new Sentence());
				Client.register("IRC", s);
			}
			if(i < n/2) s.abonner();
			// create the graphical part
			liste.add(new Irc(s));
		}
		new testWriteUpdate(liste);
	}
}
