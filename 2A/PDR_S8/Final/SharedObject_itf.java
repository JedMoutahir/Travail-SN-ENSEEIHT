
public interface SharedObject_itf{
	// Retourne l'objet partag�
	public Object read();

	// �crit la nouvelle valeur de l'objet partag� et retourne le num�ro de version associ�
	public void write(Object valeur);

	// Retourne le num�ro de version actuel de l'objet partag�
	public int getVersion();
}
