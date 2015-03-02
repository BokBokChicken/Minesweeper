import de.bezier.guido.*;
//Declare and initialize NUM_ROWS and NUM_COLS = 20
private MSButton[][] buttons; //2d array of minesweeper buttons
private ArrayList <MSButton> bombs = new ArrayList <MSButton>(); //ArrayList of just the minesweeper buttons that are mined
public final static int NUM_ROWS = 30;
public final static int NUM_COLS = 30;
void setup ()
{
    size(600, 700);
    textAlign(CENTER,CENTER);
    
    // make the manager
    Interactive.make( this );
    
    

    //declare and initialize buttons
    buttons = new MSButton [NUM_ROWS][NUM_COLS];
    for(int rows = 0; rows < NUM_ROWS; rows++)
    {   
        for(int cols = 0; cols < NUM_COLS; cols++)
        {
            buttons[rows][cols] = new MSButton(rows, cols);
        }
    }
    setBombs();
}
public void setBombs()
{
    for(int b = 0; b < 100; b++)
    {
        int row = (int)(Math.random()*30);
        int col = (int)(Math.random()*30);
        if(bombs.contains(buttons[row][col]) == false)
        {
            bombs.add(buttons[row][col]);
        }
    }
}

public void draw ()
{
    background( 0 );
    if(isWon())
        displayWinningMessage();
}
public boolean isWon()
{
    for(int rows = 0; rows < NUM_ROWS; rows++)
    {   
        for(int cols = 0; cols < NUM_COLS; cols++)
        {
            if(buttons[rows][cols].isClicked() != true)
            {
                return false;
            }
        }
    }
    return true;
}
public void displayLosingMessage()
{
   stroke(10);
   fill(255);
   for(int i = 0; i < NUM_COLS; i++)
   {
       for(int j = 0; j < NUM_ROWS; j++)
       {
           if(bombs.contains(buttons[i][j]))
           {
               buttons[i][j].clicked = true;
               buttons[i][j].draw();
           }
       }
   }
   text("You Lose", 300, 650);
   noLoop();  
}
public void displayWinningMessage()
{
   fill(0);
   stroke(10);
   text("You Win", 300, 650);
   noLoop();
}

public class MSButton
{
    private int r, c;
    private float x,y, width, height;
    private boolean clicked, marked;
    private String label;
    
    public MSButton ( int rr, int cc )
    {
        width = 600/NUM_COLS;
        height = 600/NUM_ROWS;
        r = rr;
        c = cc; 
        x = c*width;
        y = r*height;
        label = "";
        marked = clicked = false;
        Interactive.add( this ); // register it with the manager
    }
    public boolean isMarked()
    {
        return marked;
    }
    public boolean isClicked()
    {
        return clicked;
    }
    // called by manager
    
    public void mousePressed () 
    {
        clicked = true;
        if(mouseButton == RIGHT)
        {
            marked = !marked;
        }
        else if(bombs.contains(this))
        {
            displayLosingMessage();
        }
        else if(countBombs(r,c) > 0)
        {
            setLabel("" + countBombs(r,c));
        }
        else
        {
            for(int ro = r - 1; ro <= r + 1; ro++)
            {
                for(int co = c - 1; co <= c + 1; co++)
                {
                    if(isValid(ro,co) == true && buttons[ro][co].isClicked() == false && buttons[ro][co].isMarked() == false)
                    {
                        buttons[ro][co].mousePressed();
                    }
                }
            }
        }
    }

    public void draw () 
    {    
        if (marked)
            fill(0);
        else if( clicked && bombs.contains(this) ) 
            fill(255,0,0);
        else if(clicked)
            fill( 200 );
        else 
            fill( 100 );

        rect(x, y, width, height);
        fill(0);
        text(label,x+width/2,y+height/2);
    }
    public void setLabel(String newLabel)
    {
        label = newLabel;
    }
    public boolean isValid(int r, int c)
    {
        if((r < 0 || r > NUM_ROWS - 1) || (c < 0 || c > NUM_COLS - 1))
        {
            return false;
        }
        else
        {
            return true;
        }
    }
    public int countBombs(int row, int col)
    {
        int numBombs = 0;
        for(int ro = row - 1; ro <= row + 1; ro++)
        {

            for(int co = col - 1; co <= col + 1; co++)
            {

                if(isValid(ro, co) == true)
                {

                    if(bombs.contains(buttons[ro][co]) == true)
                    {
                        numBombs++;
                    }
                }
            }
        }
        return numBombs;
    }
}
