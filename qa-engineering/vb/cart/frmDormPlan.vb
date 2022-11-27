Public Class frmDormPlan

    Private Sub btnDormToMain_Click(sender As System.Object, e As System.EventArgs) Handles btnDormToMain.Click
        Me.Close()
        frmUniversityPlanner.Show()
    End Sub

    Private Sub btnDormToMeals_Click(sender As System.Object, e As System.EventArgs) Handles btnDormToMeals.Click
        Me.Close()
        frmMealPlan.Show()
    End Sub

    Private Sub btnDormToClose_Click(sender As System.Object, e As System.EventArgs) Handles btnDormToClose.Click
        Me.Close()
    End Sub

    Private Sub btnDormSelect_Click(sender As System.Object, e As System.EventArgs) Handles btnDormSelect.Click
        ' Determine the selection to add to the cart based on the selected index.
        Select Case lstDormSelections.SelectedIndex
            Case 0
                g_strName = g_strNAME_DORM_ITEM_0
                g_intPrice = g_intPRICE_DORM_ITEM_0
            Case 1
                g_strName = g_strNAME_DORM_ITEM_1
                g_intPrice = g_intPRICE_DORM_ITEM_1
            Case 2
                g_strName = g_strNAME_DORM_ITEM_2
                g_intPrice = g_intPRICE_DORM_ITEM_2
            Case 3
                g_strName = g_strNAME_DORM_ITEM_3
                g_intPrice = g_intPRICE_DORM_ITEM_3
            Case Else
                ' Display a message to the user indicating that a selection is needed.
                MessageBox.Show("Select a DORMITORY.", "Selection Needed")
        End Select
    End Sub
End Class