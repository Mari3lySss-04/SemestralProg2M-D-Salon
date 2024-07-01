<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Resultado de Inicio de Sesión</title>
    <link rel="stylesheet" href="LoginSemestral.css">
</head>
<body>
<div class="container">
    <div class="login-box">
        <div class="logo-container">
            <img src="Imagenes/Logo.png" alt="Logo">
        </div>
        <h1>Resultado de Inicio de Sesión</h1>
        <%
            String correo = request.getParameter("correo");
            String contrasena = request.getParameter("contrasena");
            String message = "";
            boolean success = false;

            try {
                Class.forName("oracle.jdbc.driver.OracleDriver");
                Connection con = DriverManager.getConnection(
                        "jdbc:oracle:thin:@localhost:1521:xe", "abiel", "2004");

                PreparedStatement ps = con.prepareStatement(
                        "SELECT contrasena FROM usuarios WHERE correo = ?");
                ps.setString(1, correo);
                ResultSet rs = ps.executeQuery();

                if (rs.next()) {
                    String dbContrasena = rs.getString("contrasena");
                    if (dbContrasena.equals(contrasena)) {
                        message = "Inicio de sesión exitoso!";
                        success = true;
                    } else {
                        message = "Contraseña incorrecta.";
                    }
                } else {
                    message = "Correo no registrado.";
                }

                con.close();
            } catch (Exception e) {
                e.printStackTrace();
                message = "Error interno, intente nuevamente.";
            }
        %>
        <p><%= message %></p>
        <script>
            setTimeout(function() {
                window.location.href = '<%= success ? "home.html" : "LoginSemestral.html" %>';
            }, 1000);
        </script>
    </div>
</div>
</body>
</html>
