Public Class frmUniversityPlanner
    Public Property EnterName As String
    Private Sub frmUniversityPlanner_Load(sender As System.Object, e As System.EventArgs) Handles MyBase.Load
        lblStudentName.Text = EnterName + "'s Selections"
    End Sub

    Private Sub btnMainToClose_Click(sender As System.Object, e As System.EventArgs) Handles btnMainToClose.Click
        Me.Close()
    End Sub

    Private Sub btnMainToMeals_Click(sender As System.Object, e As System.EventArgs) Handles btnMainToMeals.Click
        frmMealPlan.Show()
    End Sub

    Private Sub btnMainToDorms_Click(sender As System.Object, e As System.EventArgs) Handles btnMainToDorms.Click
        frmDormPlan.Show()
    End Sub

    Function CalcTotal() As Integer
        Dim intTotal As Integer = 0D

        ' Step through each item in the shopping cart.
        For intIndex = 0 To lstSelections.Items.Count - 1

            ' Get the price of each book based on the name of the book.
            Select Case lstSelections.Items.Item(intIndex).ToString()
                Case g_strNAME_DORM_ITEM_0
                    g_intPrice = g_intPRICE_DORM_ITEM_0
                Case g_strNAME_DORM_ITEM_1
                    g_intPrice = g_intPRICE_DORM_ITEM_1
                Case g_strNAME_DORM_ITEM_2
                    g_intPrice = g_intPRICE_DORM_ITEM_2
                Case g_strNAME_DORM_ITEM_3
                    g_intPrice = g_intPRICE_DORM_ITEM_3
                Case g_strNAME_MEAL_ITEM_0
                    g_intPrice = g_intPRICE_MEAL_ITEM_0
                Case g_strNAME_MEAL_ITEM_1
                    g_intPrice = g_intPRICE_MEAL_ITEM_1
                Case g_strNAME_MEAL_ITEM_2
                    g_intPrice = g_intPRICE_MEAL_ITEM_2
            End Select

            ' Keep a running total.
            intTotal += g_intPrice
        Next

        Return intTotal
    End Function

    Sub UpdateDisplayTotals()
        ' This procedure updates and displays the total.
        lblGrandTotal.Text = CalcTotal.ToString("c")

        ' Reset the price and name of the last book added to the list.
        g_intPrice = 0D
        g_strName = String.Empty
    End Sub

    Private Sub btnRemove_Click(sender As System.Object, e As System.EventArgs) Handles btnRemove.Click
        Try
            ' Remove the selected item.
            With lstSelections
                .Items.RemoveAt(.SelectedIndex)
            End With
            ' Update and display the totals.
            UpdateDisplayTotals()
        Catch ex As Exception
            ' Display a message to the user indicating that no item was selected.
            MessageBox.Show("Select an item to remove from the list.", "Selection Needed")
        End Try
    End Sub

    Private Sub frmUniversityPlanner_Activated(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Activated
        ' This subprocedure adds an item to the shopping cart and updates the totals.
        If Not (g_strName = String.Empty And g_intPrice = 0D) Then
            lstSelections.Items.Add(g_strName)
            UpdateDisplayTotals()
        End If
    End Sub

End Class
