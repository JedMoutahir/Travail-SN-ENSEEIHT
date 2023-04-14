
public interface SharedObject_itf{
	// Retourne l'objet partagé
	public Object read();

	// Écrit la nouvelle valeur de l'objet partagé et retourne le numéro de version associé
	public int write(Object valeur);

	// Retourne le numéro de version actuel de l'objet partagé
	public int getVersion();
}
