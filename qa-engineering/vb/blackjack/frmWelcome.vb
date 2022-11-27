Public Class frmWelcome

    Private Sub btnQuit_Click(sender As System.Object, e As System.EventArgs) Handles btnQuit.Click
        Application.Exit()
    End Sub

    Private Sub btnPlayNow_Click(sender As System.Object, e As System.EventArgs) Handles btnPlayNow.Click
        Dim OBJ As New frmBlackJack

        OBJ.EnterName = txtEnterName.Text()
        OBJ.Show()
    End Sub

    Private Sub btnLearnMore_Click(sender As System.Object, e As System.EventArgs) Handles btnAbout.Click
        frmAbout.ShowDialog()
    End Sub

End Class