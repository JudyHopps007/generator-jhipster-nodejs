import { Controller, Get } from '@nestjs/common';

@Controller('api')
export class AppController {
    @Get()
    root(): string {
        return 'Hello World!';
    }
}
