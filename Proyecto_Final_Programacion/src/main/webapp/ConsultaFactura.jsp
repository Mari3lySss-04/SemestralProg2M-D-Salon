<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Resultado de la Consulta de Factura</title>
    <link rel="stylesheet" href="ConsultaFactura.css">
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
        .back-button {
            display: block;
            margin: 20px auto;
            padding: 10px 20px;
            background-color: #4CAF50;
            color: white;
            text-align: center;
            text-decoration: none;
            border-radius: 4px;
        }
        .back-button:hover {
            background-color: #45a049;
        }
    </style>
</head>
<body>
<div class="form-container">
    <h1>Resultado de la Consulta de Factura</h1>
    <div class="factura-result">
        <%
            // Obtener el parámetro del número de factura
            String nFactura = request.getParameter("n_factura");

            if (nFactura != null && !nFactura.trim().isEmpty()) {
                // Variables de conexión
                Connection conn = null;
                PreparedStatement ps = null;

                try {
                    // Cargar el driver JDBC
                    Class.forName("oracle.jdbc.driver.OracleDriver");

                    // Establecer la conexión con la base de datos
                    String dbURL = "jdbc:oracle:thin:@localhost:1521:xe"; // Cambiar según la configuración de la base de datos
                    String username = "abiel"; // Cambiar por el usuario de la base de datos
                    String password = "2004"; // Cambiar por la contraseña de la base de datos
                    conn = DriverManager.getConnection(dbURL, username, password);

                    // Consultar la factura
                    String sql = "SELECT f.N_factura, f.Fecha, c.P_Nombre || ' ' || c.P_Apellido AS Cliente, col.P_Nombre || ' ' || col.P_Apellido AS Colaboradora FROM Factura f JOIN Cliente c ON f.Id_Cliente = c.Id_Cliente JOIN Colaborador col ON f.Id_Colaborador = col.Id_Colaborador WHERE f.N_factura = ?";
                    ps = conn.prepareStatement(sql);
                    ps.setString(1, nFactura);
                    ResultSet rs = ps.executeQuery();

                    if (rs.next()) {
        %>
        <h2>Detalles de la Factura</h2>
        <p><strong>Número de Factura:</strong> <%= rs.getString("N_factura") %></p>
        <p><strong>Fecha:</strong> <%= rs.getDate("Fecha") %></p>
        <p><strong>Cliente:</strong> <%= rs.getString("Cliente") %></p>
        <p><strong>Colaboradora:</strong> <%= rs.getString("Colaboradora") %></p>
        <%
        } else {
        %>
        <div class="message error">Factura no encontrada.</div>
        <a href="ConsultaFactura.html" class="back-button">Volver al formulario de consulta</a>
        <%
            }
            rs.close();
            ps.close();
        } catch (Exception e) {
            out.println("<div class='message error'>Error: " + e.getMessage() + "</div>");
        %>
        <a href="ConsultaFactura.html" class="back-button">Volver al formulario de consulta</a>
        <%
            } finally {
                // Cerrar recursos
                if (ps != null) try { ps.close(); } catch (SQLException ignore) {}
                if (conn != null) try { conn.close(); } catch (SQLException ignore) {}
            }
        } else {
        %>
        <div class="message error">Número de factura no proporcionado.</div>
        <a href="ConsultaFactura.html" class="back-button">Volver al formulario de consulta</a>
        <%
            }
        %>
    </div>
</div>
</body>
</html>
