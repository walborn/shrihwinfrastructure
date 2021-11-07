/**
 * @jest-environment jsdom
 */

 import React from 'react'
 import { render, screen } from '@testing-library/react'
 import IndexPage from '../pages/index'
 
 describe('Index page', () => {
   it('renders a button', () => {
     render(<IndexPage />)
 
     const button = screen.getByRole('button', {
       name: /myself/i,
     })
 
     expect(button).toBeInTheDocument()
   })
 })