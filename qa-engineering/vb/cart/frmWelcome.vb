Public Class frmWelcome

    Private Sub btnEnter_Click(sender As System.Object, e As System.EventArgs) Handles btnEnter.Click
        Dim Name As New frmUniversityPlanner
        Name.EnterName = txtName.Text()
        Name.Show()
    End Sub

    Private Sub btnClose_Click(sender As System.Object, e As System.EventArgs) Handles btnClose.Click
        Close()
    End Sub
End Class