/**
  * Opérateur binaire d'addition.
  *
  * @author	Xavier Crégut
  * @version	$Revision$
  */
public class Let implements Expression {

    private String name;
    private Expression leftValue;
    private Expression rightValue;
    
    public Let(String name, Expression leftValue, Expression rightValue) {
    	this.name = name;
    	this.leftValue = leftValue;
    	this.rightValue = rightValue;
    }
    
    public String getName() {
    	return this.name;
    }

    public Expression getLeftValue() {
    	return this.leftValue;
    }
    
    public Expression getRightValue() {
    	return this.rightValue;
    }
    
	public <R> R accepter(VisiteurExpression<R> visiteur) {
		return visiteur.visiterLet(this);
	}

}
