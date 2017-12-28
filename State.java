import java.util.Collection;

public interface State{
    public int get_i();
    public int get_j();
    public int get_cost();
    public boolean isFinal();
    public boolean isBad();
    public State getPrevious();
    public Collection<State> next();
}
