<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Registro de Factura - Resultado</title>
    <link rel="stylesheet" href="styles.css">
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
    <h1>Resultado del Registro de Factura</h1>
    <%
        // Obtener los parámetros del formulario
        String cedulaCliente = request.getParameter("cedula_cliente");
        String cedulaColaboradora = request.getParameter("cedula_colaboradora");
        String metodoPago = request.getParameter("metodo_pago");
        String[] servicios = request.getParameterValues("servicios[]");
        String[] cantidades = request.getParameterValues("cantidad[]");

        // Variables de conexión
        Connection conn = null;
        PreparedStatement psCliente = null;
        PreparedStatement psColaboradora = null;
        CallableStatement cs = null;

        try {
            // Validar datos
            if (cedulaCliente == null || cedulaColaboradora == null || metodoPago == null || servicios == null || cantidades == null) {
                throw new Exception("Datos de entrada incompletos.");
            }

            // Cargar el driver JDBC
            Class.forName("oracle.jdbc.driver.OracleDriver");

            // Establecer la conexión con la base de datos
            String dbURL = "jdbc:oracle:thin:@localhost:1521:xe"; // Cambiar según la configuración de la base de datos
            String username = "abiel"; // Cambiar por el usuario de la base de datos
            String password = "2004"; // Cambiar por la contraseña de la base de datos
            conn = DriverManager.getConnection(dbURL, username, password);

            // Verificar existencia del cliente
            String sqlCliente = "SELECT Id_Cliente FROM Cliente WHERE Cedula = ?";
            psCliente = conn.prepareStatement(sqlCliente);
            psCliente.setString(1, cedulaCliente);
            ResultSet rsCliente = psCliente.executeQuery();
            if (!rsCliente.next()) {
                throw new Exception("Error: Cédula de cliente no encontrada.");
            }
            int idCliente = rsCliente.getInt("Id_Cliente");
            rsCliente.close();
            psCliente.close();

            // Verificar existencia del colaborador
            String sqlColaboradora = "SELECT Id_Colaborador FROM Colaborador WHERE Cedula = ?";
            psColaboradora = conn.prepareStatement(sqlColaboradora);
            psColaboradora.setString(1, cedulaColaboradora);
            ResultSet rsColaboradora = psColaboradora.executeQuery();
            if (!rsColaboradora.next()) {
                throw new Exception("Error: Cédula de colaborador no encontrada.");
            }
            int idColaboradora = rsColaboradora.getInt("Id_Colaborador");
            rsColaboradora.close();
            psColaboradora.close();

            // Llamar al procedimiento almacenado
            String sql = "{CALL insert_factura(?, ?, ?)}";
            cs = conn.prepareCall(sql);
            cs.setInt(1, idCliente);
            cs.setInt(2, idColaboradora);
            cs.setString(3, metodoPago);

            cs.execute();
            cs.close();

            out.println("<div class='message success'>Registro de factura exitoso. Serás redirigido en breve...</div>");
            response.setHeader("Refresh", "2; URL=RegistroFacturas.html");
        } catch (Exception e) {
            out.println("<div class='message error'>Error: " + e.getMessage() + "</div>");
        } finally {
            // Cerrar recursos
            if (cs != null) try { cs.close(); } catch (SQLException ignore) {}
            if (psCliente != null) try { psCliente.close(); } catch (SQLException ignore) {}
            if (psColaboradora != null) try { psColaboradora.close(); } catch (SQLException ignore) {}
            if (conn != null) try { conn.close(); } catch (SQLException ignore) {}
        }
    %>
</div>
</body>
</html>
