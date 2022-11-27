Public Class frmAbout

    Private Sub btnCloseAbout_Click(sender As System.Object, e As System.EventArgs) Handles btnCloseAbout.Click
        Me.Close()
    End Sub

    Private Sub frmAbout_Load(sender As System.Object, e As System.EventArgs) Handles MyBase.Load
        Me.CenterToScreen()
    End Sub
End Class