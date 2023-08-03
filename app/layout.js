import './globals.css'
import { Inter } from 'next/font/google'
import { ChatAppProvider } from '@/Context/ChatAppContext'

const inter = Inter({ subsets: ['latin'] })

export const metadata = {
  title: 'Khootopia',
  description: 'Created by maushish',
}

export default function RootLayout({ children }) {
  return (
    <html lang="en">
      <body className={inter.className}>{children}</body>
    </html>
  )
}
