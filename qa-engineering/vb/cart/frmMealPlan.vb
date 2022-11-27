Public Class frmMealPlan

    Private Sub btnMealToMain_Click(sender As System.Object, e As System.EventArgs) Handles btnMealToMain.Click
        Me.Close()
        frmUniversityPlanner.Show()
    End Sub

    Private Sub btnMealToDorms_Click(sender As System.Object, e As System.EventArgs) Handles btnMealToDorms.Click
        Me.Close()
        frmDormPlan.Show()
    End Sub

    Private Sub btnMealToClose_Click(sender As System.Object, e As System.EventArgs) Handles btnMealToClose.Click
        Me.Close()
    End Sub

    Private Sub btnMealSelect_Click(sender As System.Object, e As System.EventArgs) Handles btnMealSelect.Click
        ' Determine the selection to add to the cart based on the selected index.
        Select Case lstMealSelections.SelectedIndex
            Case 0
                g_strName = g_strNAME_MEAL_ITEM_0
                g_intPrice = g_intPRICE_MEAL_ITEM_0
            Case 1
                g_strName = g_strNAME_MEAL_ITEM_1
                g_intPrice = g_intPRICE_MEAL_ITEM_1
            Case 2
                g_strName = g_strNAME_MEAL_ITEM_2
                g_intPrice = g_intPRICE_MEAL_ITEM_2
            Case Else
                ' Display a message to the user indicating that a selection is needed.
                MessageBox.Show("Select a MEAL PLAN.", "Selection Needed")
        End Select
    End Sub
End Class