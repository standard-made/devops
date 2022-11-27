Public Class frmCalculator
    'Variables to hold operands
    Private Value1 As Double
    Private Value2 As Double
    'True if "." is used, else false
    Private HasDecimal As Boolean
    Private InputStatus As Boolean
    'Variable to hold Operater
    Private CalcFunc As String

    Private Sub btnOne_Click(sender As System.Object, e As System.EventArgs) Handles btnOne.Click
        If InputStatus = False Then
            txtAnswer.Text += btnOne.Text
        Else
            txtAnswer.Text = btnOne.Text
            InputStatus = False
        End If
    End Sub

    Private Sub btnTwo_Click(sender As System.Object, e As System.EventArgs) Handles btnTwo.Click
        If InputStatus = False Then
            txtAnswer.Text += btnTwo.Text
        Else
            txtAnswer.Text = btnTwo.Text
            InputStatus = False
        End If
    End Sub

    Private Sub btnThree_Click(sender As System.Object, e As System.EventArgs) Handles btnThree.Click
        If InputStatus = False Then
            txtAnswer.Text += btnThree.Text
        Else
            txtAnswer.Text = btnThree.Text
            InputStatus = False
        End If
    End Sub

    Private Sub btnFour_Click(sender As System.Object, e As System.EventArgs) Handles btnFour.Click
        If InputStatus = False Then
            txtAnswer.Text += btnFour.Text
        Else
            txtAnswer.Text = btnFour.Text
            InputStatus = False
        End If
    End Sub

    Private Sub btnFive_Click(sender As System.Object, e As System.EventArgs) Handles btnFive.Click
        If InputStatus = False Then
            txtAnswer.Text += btnFive.Text
        Else
            txtAnswer.Text = btnFive.Text
            InputStatus = False
        End If
    End Sub

    Private Sub btnSix_Click(sender As System.Object, e As System.EventArgs) Handles btnSix.Click
        If InputStatus = False Then
            txtAnswer.Text += btnSix.Text
        Else
            txtAnswer.Text = btnSix.Text
            InputStatus = False
        End If
    End Sub

    Private Sub btnSeven_Click(sender As System.Object, e As System.EventArgs) Handles btnSeven.Click
        If InputStatus = False Then
            txtAnswer.Text += btnSeven.Text
        Else
            txtAnswer.Text = btnSeven.Text
            InputStatus = False
        End If
    End Sub

    Private Sub btnEight_Click(sender As System.Object, e As System.EventArgs) Handles btnEight.Click
        If InputStatus = False Then
            txtAnswer.Text += btnEight.Text
        Else
            txtAnswer.Text = btnEight.Text
            InputStatus = False
        End If
    End Sub

    Private Sub btnNine_Click(sender As System.Object, e As System.EventArgs) Handles btnNine.Click
        If InputStatus = False Then
            txtAnswer.Text += btnNine.Text
        Else
            txtAnswer.Text = btnNine.Text
            InputStatus = False
        End If
    End Sub

    Private Sub btnZero_Click(sender As System.Object, e As System.EventArgs) Handles btnZero.Click
        'Make sure that a 0 cannot be entered as the first number
        If InputStatus = False Then
            If txtAnswer.Text.Length >= 1 Then
                txtAnswer.Text += btnZero.Text
            End If
        End If
    End Sub

    Private Sub btnDecimal_Click(sender As System.Object, e As System.EventArgs) Handles btnDecimal.Click
        'Check for input status (we want flase)
        If Not InputStatus Then
            'Check if it already has a decimal (if it does then do nothing)
            If Not HasDecimal Then
                'Check to make sure the length is > than 1
                'Dont want user to add decimal as first character
                If txtAnswer.Text.Length > 1 Then
                    'Make sure 0 isnt the first number
                    If Not txtAnswer.Text = "0" Then
                        'It met all our requirements so add the zero
                        txtAnswer.Text += btnDecimal.Text
                        'Toggle the flag to true (only 1 decimal per calculation)
                        HasDecimal = True
                    End If
                Else
                    txtAnswer.Text = "0."
                End If
            End If
        End If
    End Sub

    Private Sub btnAdd_Click(sender As System.Object, e As System.EventArgs) Handles btnAdd.Click
        If txtAnswer.Text.Length <> 0 Then
            If CalcFunc = String.Empty Then
                Value1 = CDbl(txtAnswer.Text)
                txtAnswer.Text = String.Empty
            Else
                CalculateTotals()
            End If
            CalcFunc = "Add"
            HasDecimal = False
        End If
    End Sub

    Private Sub btnSubtract_Click(sender As System.Object, e As System.EventArgs) Handles btnSubtract.Click
        If txtAnswer.Text.Length <> 0 Then
            If CalcFunc = String.Empty Then
                Value1 = CDbl(txtAnswer.Text)
                txtAnswer.Text = String.Empty
            Else
                CalculateTotals()
            End If
            CalcFunc = "Subtract"
            HasDecimal = False
        End If
    End Sub

    Private Sub btnMultiply_Click(sender As System.Object, e As System.EventArgs) Handles btnMultiply.Click
        If txtAnswer.Text.Length <> 0 Then
            If CalcFunc = String.Empty Then
                Value1 = CDbl(txtAnswer.Text)
                txtAnswer.Text = String.Empty
            Else
                CalculateTotals()
            End If
            CalcFunc = "Multiply"
            HasDecimal = False
        End If
    End Sub

    Private Sub btnDivide_Click(sender As System.Object, e As System.EventArgs) Handles btnDivide.Click
        If txtAnswer.Text.Length <> 0 Then
            If CalcFunc = String.Empty Then
                Value1 = CDbl(txtAnswer.Text)
                txtAnswer.Text = String.Empty
            Else
                CalculateTotals()
            End If
            CalcFunc = "Divide"
            HasDecimal = False
        End If
    End Sub

    Private Sub btnClear_Click(sender As System.Object, e As System.EventArgs) Handles btnClear.Click
        txtAnswer.Text = String.Empty
        Value1 = 0
        Value2 = 0
        CalcFunc = String.Empty
        HasDecimal = False
    End Sub

    Private Sub btnEqual_Click(sender As System.Object, e As System.EventArgs) Handles btnEqual.Click
        If txtAnswer.Text.Length <> 0 AndAlso Value1 <> 0 Then
            CalculateTotals()
            CalcFunc = ""
            HasDecimal = False
        End If
    End Sub

    Private Sub CalculateTotals()
        Value2 = CDbl(txtAnswer.Text)
        Select Case calcFunc
            Case "Add"
                Value1 = Value1 + Value2
            Case "Subtract"
                Value1 = Value1 - Value2
            Case "Divide"
                Value1 = Value1 / Value2
            Case "Multiply"
                Value1 = Value1 * Value2
        End Select
        txtAnswer.Text = CStr(Value1)
        inputStatus = True
    End Sub

    Private Sub btnPercentage_Click(sender As System.Object, e As System.EventArgs) Handles btnPercentage.Click
        txtAnswer.Text = Val(txtAnswer.Text) * 100
    End Sub
End Class