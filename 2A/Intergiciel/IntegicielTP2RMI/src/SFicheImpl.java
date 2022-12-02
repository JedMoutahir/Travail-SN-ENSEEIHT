
public class SFicheImpl implements SFiche {

	String nom, email;

	public SFicheImpl(String name, String mail){
		this.nom = name;
		this.email = mail;
	}
	
	@Override
	public String getNom() {
		// TODO Auto-generated method stub
		return this.nom;
	}

	@Override
	public String getEmail() {
		// TODO Auto-generated method stub
		return this.email;
	}

}
