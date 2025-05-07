<?php
// Configuration
$recipient = "andyrobsmith@gmail"; // Your email address
$subject = "New message from contact form";

// Basic form validation
function sanitize($data) {
    return htmlspecialchars(stripslashes(trim($data)));
}

if ($_SERVER["REQUEST_METHOD"] === "POST") {
    $name = sanitize($_POST["name"]);
    $email = filter_var($_POST["email"], FILTER_VALIDATE_EMAIL);
    $subjectInput = sanitize($_POST["subject"]);
    $message = sanitize($_POST["message"]);

    if (!$email || empty($name) || empty($subjectInput) || empty($message)) {
        echo "Error: Invalid input.";
        exit;
    }

    // Construct email
    $headers = "From: $name <$email>\r\n";
    $headers .= "Reply-To: $email\r\n";
    $headers .= "Content-Type: text/html; charset=UTF-8\r\n";

    $body = "
        <h2>New Contact Form Submission</h2>
        <p><strong>Name:</strong> $name</p>
        <p><strong>Email:</strong> $email</p>
        <p><strong>Subject:</strong> $subjectInput</p>
        <p><strong>Message:</strong><br>" . nl2br($message) . "</p>
    ";

    if (mail($recipient, $subject, $body, $headers)) {
        // Redirect to a thank you page
        header("Location: thankyou.html");
        exit;
    } else {
        echo "Error: Message could not be sent.";
    }
} else {
    // Prevent direct access
    echo "Access denied.";
}
?>
