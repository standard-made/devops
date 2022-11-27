import javax.swing.*;
import java.awt.*;
import java.awt.event.*;

public class McGovernJavaProgrammingAssignment8BCrapsGUI extends JFrame
{

private static final int WIDTH=400;
private static final int HEIGHT=300;

// Declare JFrame components:
private  JButton jbutPlayCraps, jbutClear, jbutExit;

private PlayButtonHandler playHandler;
private ClearButtonHandler clearHandler;
private ExitButtonHandler exitHandler;

private JScrollPane scrollingResult;

private JTextArea jtaOutput;

private JPanel jpnlTop = new JPanel();
private JPanel jpnlCenter = new JPanel();
private JPanel jpnlBottom = new JPanel();

// Constructor

public McGovernJavaProgrammingAssignment8BCrapsGUI()
{

    //Set title and size:
    setTitle("Matthew McGovern - Java Craps Game!");
    setSize(WIDTH, HEIGHT);

    //Instantiate the JTextArea
    jtaOutput = new JTextArea(10,1);
    scrollingResult = new JScrollPane(jtaOutput);

    //Instantiate and register the Play button:
    jbutPlayCraps = new JButton("Play Craps!");
    playHandler = new PlayButtonHandler();
    jbutPlayCraps.addActionListener(playHandler);

    //Instantiate and register the Clear button:
    jbutClear = new JButton("Clear");
    clearHandler = new ClearButtonHandler();
    jbutClear.addActionListener(clearHandler);

    //Instantiate and register the Exit button:
    jbutExit = new JButton("Exit");
    exitHandler = new ExitButtonHandler();
    jbutExit.addActionListener(exitHandler);

    //Assemble the JPanels:
    jpnlTop.setLayout(new GridLayout(1, 2));
    //This is where the input box went....delete?

    jpnlCenter.setLayout(new GridLayout(1,1));
    jpnlCenter.add(scrollingResult);

    jpnlBottom.setLayout(new GridLayout(1, 3));
    jpnlBottom.add(jbutPlayCraps);
    jpnlBottom.add(jbutClear);
    jpnlBottom.add(jbutExit);

    //Start to add components to JFrame
    Container pane = getContentPane();
    pane.setLayout(new BorderLayout());

    pane.add(jpnlTop, BorderLayout.NORTH);
    pane.add(jpnlCenter, BorderLayout.CENTER);
    pane.add(jpnlBottom, BorderLayout.SOUTH);

    //Show JFrame and set "X" button to close program:
    setVisible(true);
    setDefaultCloseOperation(EXIT_ON_CLOSE);

    //Set JFrame to center:
    setLocationRelativeTo(null);

    } // end constructor.

// Play Craps button event handler:

private class PlayButtonHandler implements ActionListener
{
    public void actionPerformed(ActionEvent e)
    {
        {
            //Declare method variables.

            int iDice1,
                iDice2,
                iAddDice,
                iAddDiceRoll2 = 0,
                iGameResults;

            String sResults = "";

            //Craps game logic.

                //Roll dice.
                iDice1 = (int) (Math.random() *6 + 1);
                iDice2 = (int) (Math.random() *6 + 1);

                //Add dice together.
                iAddDice = iDice1 + iDice2;

                //Determine results.

                if (iAddDice == 2 || iAddDice == 3 || iAddDice == 12)
                {iGameResults = 1;
                sResults = "Sorry, you lost.";}

                else if (iAddDice == 7 || iAddDice == 11)
                {iGameResults = 0;
                sResults = "Congratulations, you won!";}

                else
                {iGameResults = 2;
                sResults = "Point is " + iAddDice + "\n";
                iDice1 = (int) (Math.random() *6+1);
                iDice2 = (int) (Math.random() *6+1);
                iAddDiceRoll2 = iDice1 + iDice2;
                sResults.concat("You rolled " + iAddDiceRoll2 + "\n");
                while (iAddDiceRoll2 != 7)
				{
					if (iAddDice == iAddDiceRoll2)
						{sResults.concat("Congratulations, you win!");
						break;
					}else{
						sResults = "Point is " + iAddDice + "\n";
					}
					iDice1 = (int) (Math.random() *6+1);
					iDice2 = (int) (Math.random() *6+1);
					iAddDiceRoll2 = iDice1 + iDice2;
					sResults.concat("You rolled " + iAddDiceRoll2 + "\n");
				}
                if (iAddDiceRoll2 == 7)
                {sResults = "Sorry, you lost";}


                jtaOutput.setText(sResults);


        }
    }
}


// Clear Button Handler:

private class ClearButtonHandler implements ActionListener
{
    public void actionPerformed(ActionEvent e)
    {
        jtaOutput.setText("");
    }
}

// Exit Button Handler:

private class ExitButtonHandler implements ActionListener
{
    public void actionPerformed(ActionEvent e)
    {
        System.exit(0);
    }
}

public static void main(String args[])
{
    McGovernJavaProgrammingAssignment8BCrapsGUI cs = new McGovernJavaProgrammingAssignment8BCrapsGUI();
}