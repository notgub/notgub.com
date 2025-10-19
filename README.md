# notgub.com

Personal portfolio and blog website built with modern web technologies. View it live at [notgub.com](https://notgub.com).

## Technology Stack

- **Framework**: Next.js 14
- **Language**: TypeScript
- **UI Components**: 
  - [shadcn/ui](https://ui.shadcn.com/)
  - [Magic UI](https://magicui.design/)
- **Styling**: TailwindCSS
- **Animations**: Framer Motion
- **Content**: MDX for blog posts
- **Infrastructure**: AWS ECS with Docker

## Features

- Responsive design for all devices
- Dark/Light mode support
- Blog with MDX support
- Interactive UI components
- Portfolio and Resume sections
- Docker containerization
- AWS ECS deployment

## Local Development

1. Clone this repository:
   ```bash
   git clone https://github.com/notgub/notgub.com.git
   cd notgub.com
   ```

2. Install dependencies:
   ```bash
   pnpm install
   ```

3. Start the development server:
   ```bash
   pnpm dev
   ```

4. Open [http://localhost:3000](http://localhost:3000) in your browser.

## Deployment

This project uses Docker for containerization and AWS ECS for deployment. The deployment process is automated using GitHub Actions.

### Docker

To build and run the Docker container locally:

```bash
docker build -t notgub.com .
docker run -p 3000:3000 notgub.com
```

## License

Licensed under the [MIT license](./LICENSE).
