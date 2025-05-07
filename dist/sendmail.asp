<%
CONST SMTPSendUsing = 2
CONST SMTPServer = "smtp.ionos.co.uk"
CONST SMTPServerPort = 465
CONST SMTPConnectionTimeout = 10
CONST SMTPUser = "info@sadlersauto.co.uk" 
CONST SMTPPassword = "$igAffairExp0sed"

Function Sanitize(input)
    Sanitize = Replace(Server.HTMLEncode(input), vbCrLf, "<br>")
End Function

Dim sSubject, sEmail, sMailBody, sFrom, sMsg
sFrom = Request.Form("email")
sSubject = Sanitize(Request.Form("subject"))
sEmail = "andyrobsmith@gmail.com"
sMailBody = "<strong>Name:</strong> " & Sanitize(Request.Form("name")) & "<br>" & _
            "<strong>Email:</strong> " & Sanitize(Request.Form("email")) & "<br>" & _
            "<strong>Subject:</strong> " & sSubject & "<br><br>" & _
            "<strong>Message:</strong><br>" & Sanitize(Request.Form("message"))
sMsg = ""

On Error Resume Next
Dim oMail, oConfig, oConfigFields
Set oMail = Server.CreateObject("CDO.Message")
Set oConfig = Server.CreateObject("CDO.Configuration")
Set oConfigFields = oConfig.Fields

With oConfigFields
  .Item("http://schemas.microsoft.com/cdo/configuration/sendusing") = SMTPSendUsing
  .Item("http://schemas.microsoft.com/cdo/configuration/smtpserver") = SMTPServer
  .Item("http://schemas.microsoft.com/cdo/configuration/smtpserverport") = SMTPServerPort
  .Item("http://schemas.microsoft.com/cdo/configuration/smtpauthenticate") = 1
  .Item("http://schemas.microsoft.com/cdo/configuration/sendusername") = SMTPUser
  .Item("http://schemas.microsoft.com/cdo/configuration/sendpassword") = SMTPPassword
  .Item("http://schemas.microsoft.com/cdo/configuration/sendtls") = True
  .Item("http://schemas.microsoft.com/cdo/configuration/smtpusessl") = True
  .Update
End With

oMail.Configuration = oConfig
oMail.Subject = sSubject
oMail.From = sFrom
oMail.To = sEmail
oMail.HTMLBody = sMailBody
oMail.Send

If Err.Number > 0 Then
  sMsg = "ERROR: " & Err.Description
Else
  sMsg = "Message Sent"
End If

Set oMail = Nothing
Response.Write sMsg
%>