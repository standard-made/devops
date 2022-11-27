
Public Class frmBlackJack
    Public Property EnterName As String
    Dim Card6 As Integer
    Dim Card7 As Integer
    Dim Card8 As Integer
    Dim PlayerSum As Integer
    Dim DealerSum As Integer
    Public Counter As Integer = 0

    Private Sub btnHit_Click(sender As System.Object, e As System.EventArgs) Handles btnHit.Click
        'Randomizes the card selection.
        Randomize()
        'Sets the Counter, which is triggered everytime the "Hit" button is clicked.
        Counter = Counter + 1

        ' This will declare the card and results as Integers so they can hold a value.
        Dim Card1 As Integer
        Dim Card2 As Integer
        Dim Card3 As Integer
        Dim Card4 As Integer
        Dim Card5 As Integer
        Dim Card6 As Integer
        Dim Card7 As Integer

        'Enables the "Stay" button when the "Hit" button is clicked
        If Counter >= 1 Then
            btnStay.Enabled = True
        End If

        'Triggers an event per "Hit" button click
        If Counter = 1 Then
            Card1 = (10 * Rnd() + 1)
            lblPlayerCard1.Text = Card1
            lblPlayerCard1.Visible = True            

            Card2 = (10 * Rnd() + 1)
            lblPlayerCard2.Text = Card2
            lblPlayerCard2.Visible = True

            PlayerSum = Card1 + Card2
            txtPlayerTotal.Text = PlayerSum

            Card6 = (10 * Rnd() + 1)
            lblDealerCard1.Text = Card6
            lblDealerCard1.Visible = True

            Card7 = (10 * Rnd() + 1)
            lblDealerCard2.Text = Card7
            lblDealerCard2.Visible = True

            DealerSum = Card6 + Card7
            txtDealerTotal.Text = DealerSum
            End If

        'BLACKJACK!!!!
        If Counter = 1 And PlayerSum = 21 Then
            btnHit.Enabled = False
            btnStay.Enabled = False
            frmWinnerWinner.ShowDialog()
        End If
        'YOU LOSE!!!!
        If Counter = 1 And DealerSum = 21 Then
            MsgBox("DEALER HIT BLACKJACK! YOU LOSE!")
            btnHit.Enabled = False
            btnStay.Enabled = False
        End If
        If Counter = 1 And PlayerSum > 21 Then
            MsgBox("BUST! YOU LOSE!")
            btnHit.Enabled = False
            btnStay.Enabled = False
        End If
        If Counter = 1 And DealerSum > 21 And PlayerSum <= 21 Then
            MsgBox("DEALER BUSTS! YOU WIN!")
            btnHit.Enabled = False
            btnStay.Enabled = False
        End If

        If Counter = 2 Then
            Card3 = (10 * Rnd() + 1)
            lblPlayerCard3.Text = Card3
            lblPlayerCard3.Visible = True
            picPlayerCard3.Visible = True

            PlayerSum = Val(lblPlayerCard1.Text) + Val(lblPlayerCard2.Text) + Val(lblPlayerCard3.Text)
            txtPlayerTotal.Text = PlayerSum
        End If

        If Counter = 2 And PlayerSum > 21 Then
            MsgBox("BUST! YOU LOSE!")
            btnHit.Enabled = False
            btnStay.Enabled = False
        End If

        If Counter = 3 Then
            Card4 = (10 * Rnd() + 1)
            lblPlayerCard4.Text = Card4
            lblPlayerCard4.Visible = True
            picPlayerCard4.Visible = True

            PlayerSum = Val(lblPlayerCard1.Text) + Val(lblPlayerCard2.Text) + Val(lblPlayerCard3.Text) + Val(lblPlayerCard4.Text)
            txtPlayerTotal.Text = PlayerSum
        End If

        If Counter = 3 And PlayerSum > 21 Then
            MsgBox("BUST! YOU LOSE!")
            btnHit.Enabled = False
            btnStay.Enabled = False
        End If

        If Counter = 4 Then
            Card5 = (10 * Rnd() + 1)
            lblPlayerCard5.Text = Card5
            lblPlayerCard5.Visible = True
            picPlayerCard5.Visible = True

            PlayerSum = Val(lblPlayerCard1.Text) + Val(lblPlayerCard2.Text) + Val(lblPlayerCard3.Text) + Val(lblPlayerCard4.Text) + Val(lblPlayerCard5.Text)
            txtPlayerTotal.Text = PlayerSum
        End If

        If Counter > 4 Then
            MsgBox("You cannot draw any more cards.")
            btnHit.Enabled = False
        End If
        If Counter >= 4 And PlayerSum > 21 Then
            MsgBox("BUST! YOU LOSE!")
            btnHit.Enabled = False
            btnStay.Enabled = False
        End If
    End Sub

    Private Sub frmBlackJack_Load(sender As System.Object, e As System.EventArgs) Handles MyBase.Load
        'The image selected from "Change Background Image" event is saved as the default image upon reentry into the program.
        Me.BackgroundImage = System.Drawing.Image.FromFile(My.Settings.MyBackgroundImage)

        'Displays the input name entered on the "Welcome" form.
        lblPlayerName.Text = EnterName + "'s Total"

        'The "Stay" button is disabled until the "Hit" button is clicked.
        btnStay.Enabled = False

        'Closes the main "Welcome" form
        frmWelcome.Close()
    End Sub

    Private Sub btnStay_Click(sender As System.Object, e As System.EventArgs) Handles btnStay.Click
        Dim PlayerSum As Integer = Val(txtPlayerTotal.Text)
        Dim DealerSum As Integer = Val(txtDealerTotal.Text)
        Dim Card8 As Integer
        
        'House rules: Dealer is required to "Stay" if the first two cards are more than 17.
        'House rules: Dealer must "Hit" another card if the first two cards are less than 17.
        If DealerSum >= 17 Then
        ElseIf DealerSum < 17 Then
            Card8 = (10 * Rnd() + 1)
            lblDealerCard3.Text = Card8
            lblDealerCard3.Visible = True
            picDealerCard3.Visible = True

            DealerSum = DealerSum + Card8
            txtDealerTotal.Text = DealerSum
        End If

        If DealerSum = 21 Then
            MsgBox("DEALER HIT 21! YOU LOSE!")
        ElseIf PlayerSum = DealerSum And PlayerSum < 21 Then
            MsgBox("IT'S A TIE! YOU LOSE!")
        ElseIf PlayerSum > DealerSum And PlayerSum < 21 Then
            MsgBox("YOU WIN!")
        ElseIf PlayerSum = 21 And DealerSum <> 21 Then
            MsgBox("YOU HIT 21! YOU WIN!")
        ElseIf PlayerSum > 21 Then
            MsgBox("BUST! YOU LOSE!")
        ElseIf PlayerSum < DealerSum And DealerSum < 21 Then
            MsgBox("YOU LOSE!")
        ElseIf PlayerSum < 21 And DealerSum > 21 Then
            MsgBox("DEALER BUSTS! YOU WIN!")
        End If

        'Disables the event buttons.
        btnHit.Enabled = False
        btnStay.Enabled = False
    End Sub

    Private Sub btnPlayAgain_Click(sender As System.Object, e As System.EventArgs) Handles btnPlayAgain.Click
        'Resets all fields for game restart.
        lblDealerCard1.Text = " "
        lblDealerCard2.Text = " "
        lblDealerCard3.Text = ""

        lblPlayerCard1.Text = ""
        lblPlayerCard2.Text = ""
        lblPlayerCard3.Text = ""
        lblPlayerCard5.Text = ""
        lblPlayerCard4.Text = ""

        Counter = 0

        btnHit.Enabled = True
        btnStay.Enabled = False

        lblPlayerCard3.Visible = False
        lblPlayerCard5.Visible = False
        lblPlayerCard4.Visible = False

        picPlayerCard3.Visible = False
        picPlayerCard4.Visible = False
        picPlayerCard5.Visible = False

        lblDealerCard3.Visible = False

        picDealerCard3.Visible = False

        txtPlayerTotal.Text = ""
        txtDealerTotal.Text = ""
    End Sub

    Private Sub btnMainClose_Click(sender As System.Object, e As System.EventArgs) Handles btnMainClose.Click
        Me.Close()
    End Sub

    Private Sub ChangeBackgroundImageToolStripMenuItem_Click(sender As System.Object, e As System.EventArgs) Handles ChangeBackgroundImageToolStripMenuItem.Click
        'Allows the user to choose a background image from their computer as the background image for "frmBlackJack".
        Dim ofd As New OpenFileDialog
        If ofd.ShowDialog = Windows.Forms.DialogResult.OK Then
            Me.BackgroundImage = Image.FromFile(ofd.FileName)
            My.Settings.MyBackgroundImage = ofd.FileName
            My.Settings.Save()
        End If
    End Sub

    Private Sub AboutToolStripMenuItem_Click(sender As System.Object, e As System.EventArgs) Handles AboutToolStripMenuItem.Click
        frmAbout.ShowDialog()
    End Sub

    Private Sub QuitToolStripMenuItem_Click(sender As System.Object, e As System.EventArgs) Handles QuitToolStripMenuItem.Click
        Application.Exit()
    End Sub

    Private Sub MainMenuToolStripMenuItem_Click(sender As System.Object, e As System.EventArgs) Handles MainMenuToolStripMenuItem.Click
        frmWelcome.Show()
    End Sub

    Private Sub DontTrustMeToolStripMenuItem_Click(sender As System.Object, e As System.EventArgs) Handles DontTrustMeToolStripMenuItem.Click
        frmCalculator.ShowDialog()
    End Sub
End Class
