import { Injectable, NotFoundException, ConflictException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Category } from '../entities/category.entity';
import { CreateCategoryDto } from '../dto/category_dto/create-category.dto';

@Injectable()
export class CategoriesService {
  constructor(
    @InjectRepository(Category)
    private categoriesRepository: Repository<Category>,
  ) {}

  async create(createCategoryDto: CreateCategoryDto): Promise<Category> {
    const existingCategory = await this.categoriesRepository.findOne({
      where: { name: createCategoryDto.name },
    });

    if (existingCategory) {
      throw new ConflictException('Ya existe una categoría con este nombre');
    }

    const category = this.categoriesRepository.create(createCategoryDto);
    return this.categoriesRepository.save(category);
  }

  async findAll(): Promise<Category[]> {
    return this.categoriesRepository.find({
      relations: ['subscriptions'],
      order: { name: 'ASC' },
    });
  }

  async findOne(id: string): Promise<Category> {
    const category = await this.categoriesRepository.findOne({
      where: { id },
      relations: ['subscriptions'],
    });

    if (!category) {
      throw new NotFoundException('Categoría no encontrada');
    }

    return category;
  }

  async update(id: string, updateCategoryDto: Partial<CreateCategoryDto>): Promise<Category> {
    const category = await this.findOne(id);

    if (updateCategoryDto.name) {
      const existingCategory = await this.categoriesRepository.findOne({
        where: { name: updateCategoryDto.name },
      });

      if (existingCategory && existingCategory.id !== id) {
        throw new ConflictException('Ya existe una categoría con este nombre');
      }
    }

    Object.assign(category, updateCategoryDto);
    return this.categoriesRepository.save(category);
  }

  async remove(id: string): Promise<void> {
    const category = await this.findOne(id);
    await this.categoriesRepository.remove(category);
  }

  async getCategoryStats(): Promise<any[]> {
    const categories = await this.categoriesRepository.find({
      relations: ['subscriptions'],
    });

    return categories.map(category => ({
      id: category.id,
      name: category.name,
      subscriptionCount: category.subscriptions.length,
      totalSpent: category.subscriptions.reduce((acc, sub) => acc + Number(sub.price), 0),
      icon: category.icon,
      color: category.color,
    }));
  }

  async getDefaultCategories(): Promise<Category[]> {
    const defaultCategories = [
      {
        name: 'Entretenimiento',
        description: 'Servicios de streaming, música, juegos, etc.',
        icon: 'movie',
        color: '#FF6B6B',
      },
      {
        name: 'Productividad',
        description: 'Herramientas de trabajo y productividad',
        icon: 'work',
        color: '#4ECDC4',
      },
      {
        name: 'Educación',
        description: 'Plataformas de aprendizaje y cursos',
        icon: 'school',
        color: '#45B7D1',
      },
      {
        name: 'Software',
        description: 'Aplicaciones y servicios de software',
        icon: 'code',
        color: '#96CEB4',
      },
      {
        name: 'Otros',
        description: 'Otras suscripciones',
        icon: 'more_horiz',
        color: '#9B9B9B',
      },
    ];

    const categories = await this.categoriesRepository.find();
    const existingNames = categories.map(c => c.name);

    const newCategories = defaultCategories
      .filter(cat => !existingNames.includes(cat.name))
      .map(cat => this.categoriesRepository.create(cat));

    if (newCategories.length > 0) {
      await this.categoriesRepository.save(newCategories);
    }

    return this.categoriesRepository.find({
      order: { name: 'ASC' },
    });
  }
} 