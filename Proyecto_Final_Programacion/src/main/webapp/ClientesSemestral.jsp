<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Registro de Clientes - Resultado</title>
    <link rel="stylesheet" href="ClientesSemestral.css">
    <style>
        .message {
            padding: 20px;
            color: #fff;
            text-align: center;
            border-radius: 4px;
        }
        .success {
            background-color: #4CAF50; /* Green */
        }
        .error {
            background-color: #f44336; /* Red */
        }
    </style>
</head>
<body>
<div class="form-container">
    <h1>Resultado del Registro de Clientes</h1>
    <%
        // Obtener los parámetros del formulario
        String pNombre = request.getParameter("p_nombre_cliente");
        String sNombre = request.getParameter("s_nombre_cliente");
        String pApellido = request.getParameter("p_apellido_cliente");
        String sApellido = request.getParameter("s_apellido_cliente");
        String cedula = request.getParameter("cedula_cliente");
        String tipoTelefono1 = request.getParameter("tipo_telefono_1");
        String telefono1 = request.getParameter("telefono_1");
        String tipoTelefono2 = request.getParameter("tipo_telefono_2");
        String telefono2 = request.getParameter("telefono_2");

        // Variables de conexión
        Connection conn = null;
        CallableStatement cs = null;

        try {
            // Validar cédula
            if (cedula == null || !cedula.matches("\\d{10}")) {
                throw new Exception("Cédula inválida. Debe contener 10 dígitos.");
            }

            // Cargar el driver JDBC
            Class.forName("oracle.jdbc.driver.OracleDriver");

            // Establecer la conexión con la base de datos
            String dbURL = "jdbc:oracle:thin:@localhost:1521:xe"; // Cambiar según la configuración de la base de datos
            String username = "abiel"; // Cambiar por el usuario de la base de datos
            String password = "2004"; // Cambiar por la contraseña de la base de datos
            conn = DriverManager.getConnection(dbURL, username, password);

            // Llamar al procedimiento almacenado
            String sql = "{CALL insert_cliente(?, ?, ?, ?, ?, ?, ?, ?, ?)}";
            cs = conn.prepareCall(sql);
            cs.setString(1, pNombre);
            cs.setString(2, sNombre);
            cs.setString(3, pApellido);
            cs.setString(4, sApellido);
            cs.setString(5, cedula);
            cs.setString(6, tipoTelefono1);
            cs.setString(7, telefono1);
            cs.setString(8, tipoTelefono2);
            cs.setString(9, telefono2 != null && !telefono2.isEmpty() ? telefono2 : null);

            cs.execute();
            cs.close();

            out.println("<div class='message success'>Registro exitoso. Serás redirigido en breve...</div>");
            response.setHeader("Refresh", "2; URL=ClientesSemestral.html");
        } catch (Exception e) {
            out.println("<div class='message error'>Error: " + e.getMessage() + "</div>");
        } finally {
            // Cerrar recursos
            if (cs != null) try { cs.close(); } catch (SQLException ignore) {}
            if (conn != null) try { conn.close(); } catch (SQLException ignore) {}
        }
    %>
</div>
</body>
</html>
