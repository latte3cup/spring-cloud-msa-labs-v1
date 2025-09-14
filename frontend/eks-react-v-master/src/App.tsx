import { Route, Routes } from 'react-router-dom';
import Home from './pages/home';
import LoginPage from './pages/Login';
import OrderPage from './pages/Order';
import OrdersPage from './pages/Orders';
import OrderSuccessPage from './pages/OrderSuccess';
import ProductsPage from './pages/Products';
import ProductDetailPage from './pages/ProductsDetail';

const App: React.FC = () => {
  return (
    <Routes>
      <Route path="/" element={<Home />} />
      <Route path="/login" element={<LoginPage />} />
      <Route path="/order" element={<OrderPage />} />
      <Route path="/order/success" element={<OrderSuccessPage />} />
      <Route path="/orders" element={<OrdersPage />} />
      <Route path="/products" element={<ProductsPage />} />
      <Route path="/products/:id" element={<ProductDetailPage />} />{' '}
      {/* 동적 라우트 */}
      {/* 404 페이지를 위한 라우트 */}
      <Route
        path="*"
        element={
          <h1 className="text-4xl text-red-500">
            404 - 페이지를 찾을 수 없습니다.
          </h1>
        }
      />
    </Routes>
  );
};

export default App;
